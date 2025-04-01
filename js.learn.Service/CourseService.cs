using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EllipticCurve;
using js.learn.Core.Models;
using js.learn.Data;

namespace js.learn.Service
{
    public class CourseService(ICourseRepository repository) : ICourseService
    {
        private readonly ICourseRepository _courseRepository = repository;


        public Task<List<CourseModel>> GetAll(int? categoryId = null) => _courseRepository.GetAll(categoryId);
        public Task<CourseModel?> GetDetail(int courseId) => _courseRepository.GetDetail(courseId);
    }
}
