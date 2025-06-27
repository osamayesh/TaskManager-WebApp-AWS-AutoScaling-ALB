using Microsoft.EntityFrameworkCore;
using TaskManagerAPI.Data;
using TaskManagerAPI.Models;
using TaskManagerAPI.Models.DTOs;

namespace TaskManagerAPI.Services
{
    public class TaskService : ITaskService
    {
        private readonly TaskManagerDbContext _context;
        private readonly ILogger<TaskService> _logger;

        public TaskService(TaskManagerDbContext context, ILogger<TaskService> logger)
        {
            _context = context;
            _logger = logger;
        }

        public async Task<IEnumerable<TaskResponseDto>> GetTasksAsync(int userId, TaskFilterDto filter)
        {
            try
            {
                var query = _context.Tasks.Where(t => t.UserId == userId);

                // Apply filters
                if (filter.Status.HasValue)
                {
                    query = query.Where(t => t.Status == filter.Status.Value);
                }

                if (filter.Priority.HasValue)
                {
                    query = query.Where(t => t.Priority == filter.Priority.Value);
                }

                if (filter.DueDateFrom.HasValue)
                {
                    query = query.Where(t => t.DueDate >= filter.DueDateFrom.Value);
                }

                if (filter.DueDateTo.HasValue)
                {
                    query = query.Where(t => t.DueDate <= filter.DueDateTo.Value);
                }

                if (!string.IsNullOrWhiteSpace(filter.SearchTerm))
                {
                    query = query.Where(t => t.Title.Contains(filter.SearchTerm) || 
                                           (t.Description != null && t.Description.Contains(filter.SearchTerm)));
                }

                // Apply pagination
                var tasks = await query
                    .OrderByDescending(t => t.CreatedAt)
                    .Skip((filter.PageNumber - 1) * filter.PageSize)
                    .Take(filter.PageSize)
                    .Select(t => new TaskResponseDto
                    {
                        Id = t.Id,
                        Title = t.Title,
                        Description = t.Description,
                        Status = t.Status,
                        Priority = t.Priority,
                        DueDate = t.DueDate,
                        CreatedAt = t.CreatedAt,
                        UpdatedAt = t.UpdatedAt,
                        CompletedAt = t.CompletedAt,
                        UserId = t.UserId
                    })
                    .ToListAsync();

                return tasks;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving tasks for user {UserId}", userId);
                return new List<TaskResponseDto>();
            }
        }

        public async Task<TaskResponseDto?> GetTaskByIdAsync(int taskId, int userId)
        {
            try
            {
                var task = await _context.Tasks
                    .Where(t => t.Id == taskId && t.UserId == userId)
                    .Select(t => new TaskResponseDto
                    {
                        Id = t.Id,
                        Title = t.Title,
                        Description = t.Description,
                        Status = t.Status,
                        Priority = t.Priority,
                        DueDate = t.DueDate,
                        CreatedAt = t.CreatedAt,
                        UpdatedAt = t.UpdatedAt,
                        CompletedAt = t.CompletedAt,
                        UserId = t.UserId
                    })
                    .FirstOrDefaultAsync();

                return task;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while retrieving task {TaskId} for user {UserId}", taskId, userId);
                return null;
            }
        }

        public async Task<TaskResponseDto> CreateTaskAsync(int userId, CreateTaskDto createTaskDto)
        {
            try
            {
                var task = new TaskItem
                {
                    Title = createTaskDto.Title,
                    Description = createTaskDto.Description,
                    Priority = createTaskDto.Priority,
                    DueDate = createTaskDto.DueDate,
                    Status = TaskStatus.Pending,
                    UserId = userId,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };

                _context.Tasks.Add(task);
                await _context.SaveChangesAsync();

                return new TaskResponseDto
                {
                    Id = task.Id,
                    Title = task.Title,
                    Description = task.Description,
                    Status = task.Status,
                    Priority = task.Priority,
                    DueDate = task.DueDate,
                    CreatedAt = task.CreatedAt,
                    UpdatedAt = task.UpdatedAt,
                    CompletedAt = task.CompletedAt,
                    UserId = task.UserId
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while creating task for user {UserId}", userId);
                throw;
            }
        }

        public async Task<TaskResponseDto?> UpdateTaskAsync(int taskId, int userId, UpdateTaskDto updateTaskDto)
        {
            try
            {
                var task = await _context.Tasks
                    .FirstOrDefaultAsync(t => t.Id == taskId && t.UserId == userId);

                if (task == null)
                {
                    return null;
                }

                // Update only provided fields
                if (!string.IsNullOrWhiteSpace(updateTaskDto.Title))
                {
                    task.Title = updateTaskDto.Title;
                }

                if (updateTaskDto.Description != null)
                {
                    task.Description = updateTaskDto.Description;
                }

                if (updateTaskDto.Status.HasValue)
                {
                    task.Status = updateTaskDto.Status.Value;
                    
                    // Set completion date if task is completed
                    if (updateTaskDto.Status.Value == TaskStatus.Completed && task.CompletedAt == null)
                    {
                        task.CompletedAt = DateTime.UtcNow;
                    }
                    else if (updateTaskDto.Status.Value != TaskStatus.Completed)
                    {
                        task.CompletedAt = null;
                    }
                }

                if (updateTaskDto.Priority.HasValue)
                {
                    task.Priority = updateTaskDto.Priority.Value;
                }

                if (updateTaskDto.DueDate.HasValue)
                {
                    task.DueDate = updateTaskDto.DueDate.Value;
                }

                task.UpdatedAt = DateTime.UtcNow;

                await _context.SaveChangesAsync();

                return new TaskResponseDto
                {
                    Id = task.Id,
                    Title = task.Title,
                    Description = task.Description,
                    Status = task.Status,
                    Priority = task.Priority,
                    DueDate = task.DueDate,
                    CreatedAt = task.CreatedAt,
                    UpdatedAt = task.UpdatedAt,
                    CompletedAt = task.CompletedAt,
                    UserId = task.UserId
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while updating task {TaskId} for user {UserId}", taskId, userId);
                return null;
            }
        }

        public async Task<bool> DeleteTaskAsync(int taskId, int userId)
        {
            try
            {
                var task = await _context.Tasks
                    .FirstOrDefaultAsync(t => t.Id == taskId && t.UserId == userId);

                if (task == null)
                {
                    return false;
                }

                _context.Tasks.Remove(task);
                await _context.SaveChangesAsync();

                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while deleting task {TaskId} for user {UserId}", taskId, userId);
                return false;
            }
        }

        public async Task<TaskResponseDto?> CompleteTaskAsync(int taskId, int userId)
        {
            try
            {
                var task = await _context.Tasks
                    .FirstOrDefaultAsync(t => t.Id == taskId && t.UserId == userId);

                if (task == null)
                {
                    return null;
                }

                task.Status = TaskStatus.Completed;
                task.CompletedAt = DateTime.UtcNow;
                task.UpdatedAt = DateTime.UtcNow;

                await _context.SaveChangesAsync();

                return new TaskResponseDto
                {
                    Id = task.Id,
                    Title = task.Title,
                    Description = task.Description,
                    Status = task.Status,
                    Priority = task.Priority,
                    DueDate = task.DueDate,
                    CreatedAt = task.CreatedAt,
                    UpdatedAt = task.UpdatedAt,
                    CompletedAt = task.CompletedAt,
                    UserId = task.UserId
                };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while completing task {TaskId} for user {UserId}", taskId, userId);
                return null;
            }
        }

        public async Task<int> GetTaskCountAsync(int userId)
        {
            try
            {
                return await _context.Tasks.CountAsync(t => t.UserId == userId);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while getting task count for user {UserId}", userId);
                return 0;
            }
        }
    }
} 