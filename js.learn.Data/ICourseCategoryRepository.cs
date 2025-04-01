using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using js.learn.Core.Entities;

namespace js.learn.Data
{
    public interface ICourseCategoryRepository
    {
        CourseCategory? GetById(int id);
        List<CourseCategory> GetCourseCategories();
    }
}
