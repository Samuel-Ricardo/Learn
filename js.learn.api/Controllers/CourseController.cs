using js.learn.Service;
using Microsoft.AspNetCore.Mvc;

namespace js.learn.api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CourseController: ControllerBase
    {
        private readonly ICourseService _service;

        public CourseController(ICourseService service)
        {
            this._service = service;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var category = await this._service.GetDetail(id);
            if(category == null) return NotFound();

            return Ok(category);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll(int? byCategory) => Ok(await this._service.GetAll(byCategory));


    }
}