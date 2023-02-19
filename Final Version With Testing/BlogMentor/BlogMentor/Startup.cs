using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(BlogMentor.Startup))]
namespace BlogMentor
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
