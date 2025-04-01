using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using js.learn.Core.Models;
using js.learn.Data;

namespace js.learn.Service
{
    public class CourseCategoryService(IAsyncCourseCategoryRepository repository) : ICourseCategoryService
    {
        private readonly IAsyncCourseCategoryRepository _repository = repository;

        public async Task<List<CourseCategoryModel>> GetAll()
        {
            var categories = await _repository.GetCourseCategoriesAsync();

            return categories.Select(category => new CourseCategoryModel() { 
                CategoryId = category.CategoryId,
                CategoryName = category.CategoryName,
                Description = category.Description,
            }).ToList();
        }

        public async Task<CourseCategoryModel?> GetById(int id)
        {
            var category = await _repository.GetByIdAsync(id);
            if (category == null) return null;

            return new CourseCategoryModel()
            {
                CategoryId = category.CategoryId,
                CategoryName = category.CategoryName,
                Description = category.Description
            };
        }
    }
}
