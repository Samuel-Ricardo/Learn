using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using js.learn.Core.Entities;
using js.learn.Data.Entities;

namespace js.learn.Data
{
    public class CourseCategoryRepository(LearnDbContext DbContext) : ICourseCategoryRepository
    {

        private readonly LearnDbContext _DbContext = DbContext;

        public CourseCategory? GetById(int id)
        {
            return _DbContext.CourseCategories.Find(id);
        }

        public List<CourseCategory> GetCourseCategories()
        {
            return _DbContext.CourseCategories.ToList();
        }
    }
}
