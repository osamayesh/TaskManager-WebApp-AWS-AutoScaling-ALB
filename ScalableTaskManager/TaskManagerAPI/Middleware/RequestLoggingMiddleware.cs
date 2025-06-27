using System.Diagnostics;

namespace TaskManagerAPI.Middleware
{
    public class RequestLoggingMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<RequestLoggingMiddleware> _logger;

        public RequestLoggingMiddleware(RequestDelegate next, ILogger<RequestLoggingMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            var stopwatch = Stopwatch.StartNew();

            // Log request
            _logger.LogInformation(
                "Request: {Method} {Url} {UserAgent}",
                context.Request.Method,
                context.Request.Path + context.Request.QueryString,
                context.Request.Headers["User-Agent"]);

            await _next(context);

            stopwatch.Stop();

            // Log response
            _logger.LogInformation(
                "Response: {Method} {Url} {StatusCode} {ElapsedMs}ms",
                context.Request.Method,
                context.Request.Path + context.Request.QueryString,
                context.Response.StatusCode,
                stopwatch.ElapsedMilliseconds);
        }
    }
} 