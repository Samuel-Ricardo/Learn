using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using js.learn.Core.Entities;

namespace js.learn.Data
{
    public interface IAsyncCourseCategoryRepository
    {
        Task<CourseCategory?> GetByIdAsync(int   id);
        Task<List<CourseCategory>> GetCourseCategoriesAsync();
    }
}
