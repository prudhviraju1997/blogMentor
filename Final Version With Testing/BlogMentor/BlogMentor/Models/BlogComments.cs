//------------------------------------------------------------------------------
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
    using System.Collections.Generic;
    
    public partial class BlogComments
    {
        public long ID { get; set; }
        public Nullable<long> BlogID { get; set; }
        public string CommentText { get; set; }
        public Nullable<System.DateTime> CommentDate { get; set; }
        public Nullable<bool> IsApproved { get; set; }
        public Nullable<int> UserID { get; set; }
    
        public virtual Users Users { get; set; }
        public virtual Blogs Blogs { get; set; }
    }
}
