using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BlogMentor.Models
{
    public class UserViewModel
    {
        public List<Users> refUser = new List<Users>();
        public List<Users> refUsers = new List<Users>();
        public List<RefUserType> refUserType = new List<RefUserType>();
        public Blogs blog = new Blogs();
        public List<Blogs> blogs = new List<Blogs>();
        public List<BlogComments> blogComments = new List<BlogComments>();
        public List<spGetBlogComments_Result> spGetBlogComments = new List<spGetBlogComments_Result>();
        public List<spGetBlogs_Result> spGetBlogs = new List<spGetBlogs_Result>();
        public spGetBlogs_Result spGetBlog = new spGetBlogs_Result();
    }
}