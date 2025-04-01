using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using js.learn.Core.Models;

namespace js.learn.Service
{
    public interface ICourseCategoryService
    {
        Task<CourseCategoryModel?> GetById(int id);
        Task<List<CourseCategoryModel>> GetAll();
    }
}
