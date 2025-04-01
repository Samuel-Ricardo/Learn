using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using js.learn.Core.Models;

namespace js.learn.Service
{
    public interface ICourseService
    {
        Task<List<CourseModel>> GetAll(int? categoryId = null);
        Task<CourseModel?> GetDetail(int courseId);
    }
}
