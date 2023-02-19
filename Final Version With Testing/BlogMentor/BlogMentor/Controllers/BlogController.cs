using BlogMentor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BlogMentor.Controllers
{
    public class BlogController : Controller
    {
        // GET: Blog
        BlogMentorEntities db = new BlogMentorEntities();
        UserViewModel uvm = new UserViewModel();

        public ActionResult MyBlogs()
        {
            TempData["Page"] = "MyBlogs";
            var UserID = 0; 
            if(Session != null)
            {
                UserID = Convert.ToInt32(Session["UserID"]);
                uvm.blogs = (from x in db.Blogs where x.UserID == UserID select x).ToList();
            }            
            return View(uvm);
        }

        public ActionResult BlogDetails(long? BlogID)
        {
            uvm.spGetBlog = db.spGetBlogs(BlogID, "Acending").FirstOrDefault();
            uvm.spGetBlogComments = db.spGetBlogComments(BlogID).ToList();
            TempData["TypeID"] = Session["TypeID"] == null ? 0 : Session["TypeID"];
            return View(uvm);
        }

        public JsonResult commentAction(long CommentID, string reqAction)
        {
            var comment = (from x in db.BlogComments where x.ID == CommentID select x).FirstOrDefault();
            if (reqAction == "Approved")
            {
                comment.IsApproved = true;
            }
            else
            {
                db.BlogComments.Remove(comment);
            }
            db.SaveChanges();
            return Json("Done", JsonRequestBehavior.AllowGet);
        }
        
        [HttpPost]
        public ActionResult BlogDetails(BlogComments bc)
        {
            var BlogID = bc.BlogID;
            var UserID = Convert.ToInt32(Session["UserID"]);           
            bc.CommentDate = DateTime.Now;
            if(UserID == 0)
            {
                bc.UserID = null;
                bc.IsApproved = false;
            }
            else
            {
                bc.UserID = UserID;
                bc.IsApproved = true;
            }
            db.BlogComments.Add(bc);
            db.SaveChanges();
            uvm.spGetBlog = db.spGetBlogs(BlogID, "Acending").FirstOrDefault();
            uvm.spGetBlogComments = db.spGetBlogComments(BlogID).ToList();
            TempData["TypeID"] = Session["TypeID"] == null ? 0 : Session["TypeID"];
            TempData["Msg"] = "Done";
            return View(uvm);
        }

        [CustomAction]
        public ActionResult DeleteBlog(long? BlogID, string callingAction, string callingController)
        {
            var bb = (from x in db.Blogs where x.ID == BlogID select x).FirstOrDefault();
            var cc = (from y in db.BlogComments where y.BlogID == BlogID select y).ToList();
            foreach(var item in cc)
            {
                db.BlogComments.Remove(item);
            }
            db.Blogs.Remove(bb);
            db.SaveChanges();
            TempData["Msg"] = "Deleted";
            return RedirectToAction(callingAction, callingController);
        }

        [CustomAction]
        public ActionResult CreateBlog(long? BlogID)
        {
            int userTypeID = (int)Session["TypeID"];
            if (userTypeID == 1 || userTypeID == 2)
            {
                uvm.refUser = (from x in db.Users where x.IsApproved == false select x).ToList();
                if(BlogID != null || BlogID != 0)
                {
                    uvm.blog = (from x in db.Blogs where x.ID == BlogID select x).FirstOrDefault();
                    TempData["BlogID"] = BlogID;
                }
                return View(uvm);
            }
            return RedirectToAction("Login", "Login");
        }

        [CustomAction]
        [HttpPost]
        public ActionResult CreateBlog(FormCollection myForm, HttpPostedFileBase file)
        {
            var fname = "";
            var userID = Convert.ToInt32(Session["UserID"]);
            var Tags = myForm["tags"].ToString();
            var Title = myForm["title"].ToString();
            var Quote = myForm["quote"].ToString();
            var Description = myForm["description"].ToString();
            var BlogID = Convert.ToInt64(myForm["BlogID"]);
            if(BlogID == 0) {
                Blogs bl = new Blogs();
                bl.Tags = Tags;
                bl.Title = Title;
                bl.Quote = Quote;
                bl.Description = Description;
                bl.Dated = DateTime.Now;
                bl.UserID = userID;
                db.Blogs.Add(bl);
                db.SaveChanges();
                var blogID = bl.ID;
                try
                {
                    string modFilName = "";
                    string sPath = System.Web.Hosting.HostingEnvironment.MapPath("/Content/theme/img/blogPics/");
                    bool folderExists = System.IO.Directory.Exists(sPath);
                    if (!folderExists)
                        System.IO.Directory.CreateDirectory(sPath);
                    if (file != null && file.ContentLength > 0)
                    {
                        fname = file.FileName;
                        fname = userID + ".jpg";
                        var user = (from x in db.Users where x.ID == userID select x).FirstOrDefault();
                        var blog = (from x in db.Blogs where x.ID == blogID select x).FirstOrDefault();

                        string[] fn = fname.ToString().Split('.');
                        string nfn = user.FullName + "" + blogID + "." + fn[1];
                        modFilName = nfn.ToString();

                        file.SaveAs(sPath + System.IO.Path.GetFileName(modFilName));
                        blog.CoverPicUrl = "/Content/theme/img/blogPics/" + modFilName;
                        db.SaveChanges();
                    }
                    TempData["Msg"] = "Done";
                    uvm.blog = null;
                    int userTypeID = (int)Session["TypeID"];
                    if (userTypeID == 1)
                    {
                        return RedirectToAction("Panel", "AdminPanel");
                    }
                    else
                    {
                        return RedirectToAction("MyBlogs", "Blog");
                    }
                }
                catch (Exception ex)
                {
                    TempData["Messages"] = "Error";
                    int userTypeID = (int)Session["TypeID"];
                    if (userTypeID == 1)
                    {
                        return RedirectToAction("Panel", "AdminPanel");
                    }
                    else
                    {
                        return RedirectToAction("MyBlogs", "Blog");
                    }
                }
            }
            else
            {
                Blogs bg = (from x in db.Blogs where x.ID == BlogID select x).FirstOrDefault();
                bg.Tags = Tags;
                bg.Title = Title;
                bg.Quote = Quote;
                bg.Description = Description;
                db.SaveChanges();
                TempData["Msg"] = "Updated";
                uvm.blog = null;
                int userTypeID = (int)Session["TypeID"];
                if (userTypeID == 1)
                {
                    return RedirectToAction("Panel", "AdminPanel");
                }
                else
                {
                    return RedirectToAction("MyBlogs", "Blog");
                }
            }
        }
    }
}