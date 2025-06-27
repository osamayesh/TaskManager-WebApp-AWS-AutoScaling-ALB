using TaskManagerAPI.Models.DTOs;

namespace TaskManagerAPI.Services
{
    public interface ITaskService
    {
        Task<IEnumerable<TaskResponseDto>> GetTasksAsync(int userId, TaskFilterDto filter);
        Task<TaskResponseDto?> GetTaskByIdAsync(int taskId, int userId);
        Task<TaskResponseDto> CreateTaskAsync(int userId, CreateTaskDto createTaskDto);
        Task<TaskResponseDto?> UpdateTaskAsync(int taskId, int userId, UpdateTaskDto updateTaskDto);
        Task<bool> DeleteTaskAsync(int taskId, int userId);
        Task<TaskResponseDto?> CompleteTaskAsync(int taskId, int userId);
        Task<int> GetTaskCountAsync(int userId);
    }
} 