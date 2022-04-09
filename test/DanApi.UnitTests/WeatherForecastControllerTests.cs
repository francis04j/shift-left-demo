using System;
using Xunit;
using Microsoft.Extensions.Logging.Abstractions;
using DanApi.Controllers;

namespace DanApi.UnitTests
{
    public class WeatherForecastControllerTests
    {
        [Fact]
        public void should_return_list_of_values()
        {
            var logger = new NullLogger<WeatherForecastController>();
            var controller = new WeatherForecastController(logger);

            var result = controller.Get();

            Assert.NotNull(result);
        }
    }
}
