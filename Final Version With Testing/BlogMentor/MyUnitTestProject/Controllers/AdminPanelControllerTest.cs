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
    public class AdminPanelControllerTest
    {
        [TestMethod]
        public void Panel()
        {
            //Arrange
            AdminPanelController controller = new AdminPanelController();

            //Act
            ViewResult result = controller.Panel() as ViewResult;

            //Assert
            Assert.AreEqual("Admin", result.ViewBag.UserRole);
        }
    }
}
