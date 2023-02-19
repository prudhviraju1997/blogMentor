﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace BlogMentor.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class BlogMentorEntities : DbContext
    {
        public BlogMentorEntities()
            : base("name=BlogMentorEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<BlogComments> BlogComments { get; set; }
        public virtual DbSet<RefUserType> RefUserType { get; set; }
        public virtual DbSet<Users> Users { get; set; }
        public virtual DbSet<Blogs> Blogs { get; set; }
    
        public virtual ObjectResult<spGetBlogComments_Result> spGetBlogComments(Nullable<long> blogID)
        {
            var blogIDParameter = blogID.HasValue ?
                new ObjectParameter("BlogID", blogID) :
                new ObjectParameter("BlogID", typeof(long));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<spGetBlogComments_Result>("spGetBlogComments", blogIDParameter);
        }
    
        public virtual ObjectResult<spGetBlogs_Result> spGetBlogs(Nullable<long> blogID, string sortOrder)
        {
            var blogIDParameter = blogID.HasValue ?
                new ObjectParameter("BlogID", blogID) :
                new ObjectParameter("BlogID", typeof(long));
    
            var sortOrderParameter = sortOrder != null ?
                new ObjectParameter("SortOrder", sortOrder) :
                new ObjectParameter("SortOrder", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<spGetBlogs_Result>("spGetBlogs", blogIDParameter, sortOrderParameter);
        }
    }
}