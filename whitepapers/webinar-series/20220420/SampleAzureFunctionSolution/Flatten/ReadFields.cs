using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using iText.Forms;
using iText.Forms.Fields;
using iText.Kernel.Pdf;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;

namespace Flatten
{
    public static class ReadFields
    {
        [FunctionName("ReadFields")]
        [OpenApiOperation(operationId: "Run", tags: new[] { "name" })]
        [OpenApiSecurity("function_key", SecuritySchemeType.ApiKey, Name = "code", In = OpenApiSecurityLocationType.Query)]
        [OpenApiParameter(name: "name", In = ParameterLocation.Query, Required = true, Type = typeof(string), Description = "The **Name** parameter")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "text/plain", bodyType: typeof(string), Description = "The OK response")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            //string name = req.Query["name"];

            Stream pdfForm = req.Body;
            MemoryStream memStream = new MemoryStream();
            req.Body.CopyTo(memStream);
            var reader = new PdfReader(memStream);
            reader.SetUnethicalReading(true);
            var doc = new PdfDocument(reader);

            var builder = ImmutableDictionary.CreateBuilder<string, PdfFormField>();
            PdfAcroForm.GetAcroForm(doc, false).GetFormFields().ToList().ForEach(x => builder.Add(x.Key, x.Value));
                                  
            var entries = builder.Select(d =>
            string.Format("\"{0}\": \"{1}\"", d.Key, string.Join(",", d.Value)));


            return new OkObjectResult("{" + string.Join(",", entries) + "}");
        }
    }
}