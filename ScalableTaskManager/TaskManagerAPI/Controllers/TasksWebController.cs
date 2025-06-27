using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using TaskManagerAPI.Models;
using TaskManagerAPI.Models.DTOs;
using TaskManagerAPI.Services;

namespace TaskManagerAPI.Controllers
{
    [Authorize]
    public class TasksWebController : Controller
    {
        private readonly ITaskService _taskService;
        private readonly ILogger<TasksWebController> _logger;

        public TasksWebController(ITaskService taskService, ILogger<TasksWebController> logger)
        {
            _taskService = taskService;
            _logger = logger;
        }

        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return int.Parse(userIdClaim ?? "0");
        }

        public async Task<IActionResult> Index(TaskFilterDto filter)
        {
            try
            {
                var userId = GetCurrentUserId();
                if (userId == 0)
                {
                    return RedirectToAction("Login", "Account");
                }

                var tasks = await _taskService.GetTasksAsync(userId, filter);
                ViewBag.Filter = filter;
                ViewBag.UserName = User.FindFirst(ClaimTypes.Name)?.Value;
                
                return View(tasks);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving tasks");
                TempData["Error"] = "An error occurred while retrieving tasks";
                return View(new List<TaskResponseDto>());
            }
        }

        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(CreateTaskDto model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                var userId = GetCurrentUserId();
                if (userId == 0)
                {
                    return RedirectToAction("Login", "Account");
                }

                await _taskService.CreateTaskAsync(userId, model);
                TempData["Success"] = "Task created successfully";
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating task");
                ModelState.AddModelError("", "An error occurred while creating the task");
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            try
            {
                var userId = GetCurrentUserId();
                if (userId == 0)
                {
                    return RedirectToAction("Login", "Account");
                }

                var task = await _taskService.GetTaskByIdAsync(id, userId);
                if (task == null)
                {
                    TempData["Error"] = "Task not found";
                    return RedirectToAction("Index");
                }

                var model = new UpdateTaskDto
                {
                    Title = task.Title,
                    Description = task.Description,
                    Status = task.Status,
                    Priority = task.Priority,
                    DueDate = task.DueDate
                };

                ViewBag.TaskId = id;
                return View(model);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving task for edit");
                TempData["Error"] = "An error occurred while retrieving the task";
                return RedirectToAction("Index");
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, UpdateTaskDto model)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.TaskId = id;
                return View(model);
            }

            try
            {
                var userId = GetCurrentUserId();
                if (userId == 0)
                {
                    return RedirectToAction("Login", "Account");
                }

                var result = await _taskService.UpdateTaskAsync(id, userId, model);
                if (result == null)
                {
                    TempData["Error"] = "Task not found or you don't have permission to edit it";
                    return RedirectToAction("Index");
                }

                TempData["Success"] = "Task updated successfully";
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating task");
                ModelState.AddModelError("", "An error occurred while updating the task");
                ViewBag.TaskId = id;
                return View(model);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                var userId = GetCurrentUserId();
                if (userId == 0)
                {
                    return RedirectToAction("Login", "Account");
                }

                var result = await _taskService.DeleteTaskAsync(id, userId);
                if (!result)
                {
                    TempData["Error"] = "Task not found or you don't have permission to delete it";
                }
                else
                {
                    TempData["Success"] = "Task deleted successfully";
                }

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting task");
                TempData["Error"] = "An error occurred while deleting the task";
                return RedirectToAction("Index");
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Complete(int id)
        {
            try
            {
                var userId = GetCurrentUserId();
                if (userId == 0)
                {
                    return RedirectToAction("Login", "Account");
                }

                var result = await _taskService.CompleteTaskAsync(id, userId);
                if (result == null)
                {
                    TempData["Error"] = "Task not found or you don't have permission to complete it";
                }
                else
                {
                    TempData["Success"] = "Task marked as completed";
                }

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while completing task");
                TempData["Error"] = "An error occurred while completing the task";
                return RedirectToAction("Index");
            }
        }

        [HttpGet]
        public async Task<IActionResult> Details(int id)
        {
            try
            {
                var userId = GetCurrentUserId();
                if (userId == 0)
                {
                    return RedirectToAction("Login", "Account");
                }

                var task = await _taskService.GetTaskByIdAsync(id, userId);
                if (task == null)
                {
                    TempData["Error"] = "Task not found";
                    return RedirectToAction("Index");
                }

                return View(task);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving task details");
                TempData["Error"] = "An error occurred while retrieving task details";
                return RedirectToAction("Index");
            }
        }
    }
} 