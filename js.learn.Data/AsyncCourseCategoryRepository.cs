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
    public class AsyncCourseCategoryRepository(LearnDbContext dbContext) : IAsyncCourseCategoryRepository
    {

        private readonly LearnDbContext _dbContext = dbContext;

        public Task<CourseCategory?> GetByIdAsync(int id) => _dbContext.CourseCategories.FindAsync(id).AsTask();
        

        public Task<List<CourseCategory>> GetCourseCategoriesAsync() => _dbContext.CourseCategories.ToListAsync();
    }
}
