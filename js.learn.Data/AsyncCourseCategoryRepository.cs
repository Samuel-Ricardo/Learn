using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using js.learn.Core.Entities;
using js.learn.Data.Entities;
using Microsoft.EntityFrameworkCore;

namespace js.learn.Data
{
    internal class AsyncCourseCategoryRepository(LearnDbContext dbContext) : IAsyncCourseCategoryRepository
    {

        private readonly ICourseCategoryRepository _courseCategoryRepository;

        public Task<CourseCategory?> GetByIdAsync(int id) => dbContext.CourseCategories.FindAsync(id).AsTask();
        

        public Task<List<CourseCategory>> GetCourseCategoriesAsync() => dbContext.CourseCategories.ToListAsync();
    }
}
