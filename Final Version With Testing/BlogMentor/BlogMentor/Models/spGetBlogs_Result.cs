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
    
    public partial class spGetBlogs_Result
    {
        public long ID { get; set; }
        public string Title { get; set; }
        public string Tags { get; set; }
        public string Description { get; set; }
        public string CoverPicUrl { get; set; }
        public string Quote { get; set; }
        public Nullable<System.DateTime> Dated { get; set; }
        public Nullable<int> UserID { get; set; }
        public string FullName { get; set; }
    }
}
