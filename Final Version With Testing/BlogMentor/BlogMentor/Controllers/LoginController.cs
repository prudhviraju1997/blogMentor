using BlogMentor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BlogMentor.Controllers
{
    public class LoginController : Controller
    {
        // GET: Login    
        BlogMentorEntities db = new BlogMentorEntities();
        UserViewModel uvm = new UserViewModel();

        public ActionResult Login()
        {
            return View();
        }
        
        [HttpPost]
        public ActionResult Login(FormCollection myForm)
        {
            var un = myForm["userName"].ToString();
            var pass = myForm["password"].ToString();
            var obj = db.Users.Where(x => x.Username == un).FirstOrDefault();
            if (obj == null)
                @TempData["message"] = "Incorrect Username";
            else if (obj.Password != pass)
                @TempData["message"] = "Incorrect Password";
            else if(obj.IsApproved == false)
                @TempData["message"] = "User Unauthorized";
            else
            {
                Session["TypeID"] = obj.UserTypeID;
                Session["UserID"] = obj.ID;
                Session["UserName"] = obj.FullName;
                if(obj.UserTypeID == 1)
                {
                    return RedirectToAction("Panel", "AdminPanel");
                }
                else if(obj.UserTypeID == 2)
                {
                    return RedirectToAction("MyBlogs", "Blog");
                }
                else if(obj.UserTypeID == 3)
                {
                    return RedirectToAction("Index", "Home");
                }
                
            }
            return RedirectToAction("Login", "Login");
        }

        public ActionResult SignUp()
        {
            uvm.refUserType = db.RefUserType.ToList();
            return View(uvm);
        }

        [HttpPost]
        public ActionResult SignUp(Users ur)
        {
            try
            {
                ur.IsApproved = false;
                db.Users.Add(ur);
                db.SaveChanges();
                TempData["Message"] = "Done";
            }
            catch (Exception)
            {
                TempData["Message"] = "Error";
            }
            uvm.refUserType = db.RefUserType.ToList();
            return View(uvm);
        }

        public ActionResult Logout()
        {
            Session["TypeID"] = null;
            Session["UserID"] = null;
            Session["UserName"] = null;
            return RedirectToAction("Login", "Login");
        }
    }
}