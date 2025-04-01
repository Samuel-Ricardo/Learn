using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using js.learn.Core.Entities;

namespace js.learn.Core.Models
{
    public class CourseCategoryModel
    {
        
        public int CategoryId { get; set; }

        public string CategoryName { get; set; } = null!;

        public string? Description { get; set; }

        public virtual ICollection<Course> Courses { get; set; } = new List<Course>();

    }
}
