using js.learn.Service;
using Microsoft.AspNetCore.Mvc;

namespace js.learn.api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CourseCategoryController: ControllerBase
    {
        private readonly ICourseCategoryService _service;

        public CourseCategoryController(ICourseCategoryService service)
        {
            this._service = service;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var category = await this._service.GetById(id);
            if(category == null) return NotFound();

            return Ok(category);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll() => Ok(await this._service.GetAll());


    }
}