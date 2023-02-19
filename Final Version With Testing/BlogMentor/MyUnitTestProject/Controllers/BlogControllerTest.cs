using System;
using System.Collections.Generic;
using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BlogMentor;
using BlogMentor.Controllers;

namespace MyUnitTestProject.Controllers
{
    [TestClass]
    public class BlogControllerTest
    {
        [TestMethod]
        public void MyBlogs()
        {
            //Arrange
            BlogController controller = new BlogController();

            //Act
            ViewResult result = controller.MyBlogs() as ViewResult;
            var aa = result.TempData["Page"];

            //Assert
            Assert.AreEqual("MyBlogss", aa);
        }
    }
}
