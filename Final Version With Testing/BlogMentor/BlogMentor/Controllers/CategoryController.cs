using BlogMentor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BlogMentor.Controllers
{
    public class CategoryController : Controller
    {
        // GET: Category
        BlogMentorEntities db = new BlogMentorEntities();
        UserViewModel uvm = new UserViewModel();
        public ActionResult Category()
        {
            uvm.blogs = db.Blogs.ToList();
            TempData["TypeID"] = Session["TypeID"] == null ? 0 : Session["TypeID"];
            return View(uvm);
        }

        [HttpPost]
        public ActionResult Category(string cat)
        {
            var Tag = cat;
            uvm.blogs = (from c in db.Blogs
                         where c.Tags.Contains(Tag)
                        select c).ToList();
            TempData["TypeID"] = Session["TypeID"] == null ? 0 : Session["TypeID"];
            return View(uvm);
        }
    }
}