
using js.learn.Data;
using js.learn.Data.Entities;
using js.learn.Service;
using Microsoft.EntityFrameworkCore;

namespace js.learn.api;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);
        var configuration = builder.Configuration;

        builder.Services.AddDbContextPool<LearnDbContext>(options =>
        {
            options.UseSqlServer(
                configuration.GetConnectionString("DbContext"), 
                providerOptions => providerOptions.EnableRetryOnFailure()
             );
        });

        // Add services to the container.

        builder.Services.AddControllers();
        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();


        builder.Services.AddScoped<ICourseCategoryRepository, CourseCategoryRepository>();
        builder.Services.AddScoped<IAsyncCourseCategoryRepository, AsyncCourseCategoryRepository>();

        builder.Services.AddScoped<ICourseCategoryService, CourseCategoryService>();



        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (app.Environment.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI();
        }

        app.UseHttpsRedirection();

        app.UseAuthorization();


        app.MapControllers();

        app.Run();
    }
}
