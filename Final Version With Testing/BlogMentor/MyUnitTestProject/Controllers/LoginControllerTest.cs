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
    public class LoginControllerTest
    {
        [TestMethod]
        public void Login()
        {
            //Arrange
            LoginController controller = new LoginController();

            //Act
            ActionResult result = controller.Login() as ActionResult;

            //Assert
            Assert.IsNotNull(result);
        }
    }
}
