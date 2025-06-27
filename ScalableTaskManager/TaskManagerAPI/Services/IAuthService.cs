using TaskManagerAPI.Models.DTOs;

namespace TaskManagerAPI.Services
{
    public interface IAuthService
    {
        Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto);
        Task<AuthResponseDto> LoginAsync(LoginDto loginDto);
        Task<string> GenerateJwtTokenAsync(int userId, string email, string role);
        Task<bool> ValidateTokenAsync(string token);
    }
} 