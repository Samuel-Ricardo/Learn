using js.learn.Data.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace js.learn.api.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    private readonly ILogger<WeatherForecastController> _logger;
    private readonly LearnDbContext _dbContext;

    public WeatherForecastController(ILogger<WeatherForecastController> logger, LearnDbContext dbContext)
    {
        _dbContext = dbContext;
        _logger = logger;
    }

    [HttpGet(Name = "GetWeatherForecast")]
    public IActionResult Get()
    {
        var courses = _dbContext.Courses.ToList();
        return Ok(courses);
    }
}
