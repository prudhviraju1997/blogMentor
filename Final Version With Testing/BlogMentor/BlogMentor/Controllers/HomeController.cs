using BlogMentor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BlogMentor.Controllers
{
    public class HomeController : Controller
    {
        BlogMentorEntities db = new BlogMentorEntities();
        UserViewModel uvm = new UserViewModel();
        public ActionResult Index()
        {
            uvm.spGetBlogs = db.spGetBlogs(0, "Acending").ToList();
            TempData["TypeID"] = Session["TypeID"] == null ? 0 : Session["TypeID"];
            return View(uvm);
        }

        [HttpPost]
        public ActionResult Index(FormCollection myForm)
        {
            var SO = myForm["dateOrder"].ToString() == "Newer" ? "Acending" : "Decending";
            uvm.spGetBlogs = db.spGetBlogs(0, SO).ToList();
            TempData["TypeID"] = Session["TypeID"] == null ? 0 : Session["TypeID"];
            return View(uvm);
        }
    }
}