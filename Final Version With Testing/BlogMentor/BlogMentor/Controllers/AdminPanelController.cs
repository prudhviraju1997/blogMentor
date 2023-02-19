using BlogMentor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BlogMentor.Controllers
{
    public class AdminPanelController : Controller
    {
        // GET: AdminPanel
        BlogMentorEntities db = new BlogMentorEntities();
        UserViewModel uvm = new UserViewModel();

        [CustomAction]
        public ActionResult Panel()
        {
             if (Session != null)
            {
                uvm.refUser = (from x in db.Users where x.IsApproved == false select x).ToList();
                uvm.refUsers = (from x in db.Users where x.UserTypeID != 4 select x).ToList();
                uvm.refUserType = (from x in db.RefUserType where x.ID != 4 select x).ToList();
                uvm.blogs = (from x in db.Blogs orderby x.ID descending select x).Take(9).ToList();
                
            }
            ViewBag.UserRole = "Admin";
            return View(uvm);
        }

        public JsonResult RequestAction(int UserID, string reqAction)
        {
            var user = (from x in db.Users where x.ID == UserID select x).FirstOrDefault();
            if (reqAction == "Approved")
            {
                user.IsApproved = true;
            }
            else
            {
                db.Users.Remove(user);
            }
            db.SaveChanges();
            return Json("Done", JsonRequestBehavior.AllowGet);
        }

        public JsonResult changeRole(int UserID, int RoleID)
        {
            var user = (from x in db.Users where x.ID == UserID select x).FirstOrDefault();
            user.UserTypeID = RoleID;
            db.SaveChanges();
            return Json("Done", JsonRequestBehavior.AllowGet);
        }
    }
}