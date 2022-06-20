using System.IO;
using System.Net;
using System.Threading.Tasks;
using iText.Forms;
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
    public static class UnlockPDF
    {
        [FunctionName("UnlockPDF")]
        [OpenApiOperation(operationId: "Run", tags: new[] { "name" })]
        [OpenApiSecurity("function_key", SecuritySchemeType.ApiKey, Name = "code", In = OpenApiSecurityLocationType.Query)]
        [OpenApiParameter(name: "name", In = ParameterLocation.Query, Required = true, Type = typeof(string), Description = "The **Name** parameter")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "text/plain", bodyType: typeof(string), Description = "The OK response")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            Stream pdfForm = req.Body;

            //MemoryStream workstream = new MemoryStream();
            //using (var workstream = new MemoryStream())
            //{ 
            //PdfReader reader = new PdfReader(pdfForm);
            //EncryptionProperties myProperties = new EncryptionProperties();
            //myProperties.SetStandardEncryption(null, null, EncryptionConstants.ALLOW_COPY
            //    | EncryptionConstants.ALLOW_DEGRADED_PRINTING | EncryptionConstants.ALLOW_FILL_IN
            //    | EncryptionConstants.ALLOW_MODIFY_ANNOTATIONS | EncryptionConstants.ALLOW_MODIFY_CONTENTS
            //    | EncryptionConstants.ALLOW_PRINTING | EncryptionConstants.ALLOW_SCREENREADERS, EncryptionConstants.DO_NOT_ENCRYPT_METADATA);


            //PdfEncryptor.Encrypt(reader, workstream, myProperties, null);
            //    workstream.Position = 0;
            //return new OkObjectResult(workstream);

            using (MemoryStream input = new MemoryStream())
            {
                using (MemoryStream output = new MemoryStream())
                {
                    PdfReader reader = new PdfReader(pdfForm);
                    
                    reader.SetUnethicalReading(true);
                    EncryptionProperties myProperties = new EncryptionProperties();
                    myProperties.SetStandardEncryption(null, null, EncryptionConstants.ALLOW_COPY
                        | EncryptionConstants.ALLOW_DEGRADED_PRINTING | EncryptionConstants.ALLOW_FILL_IN
                        | EncryptionConstants.ALLOW_MODIFY_ANNOTATIONS | EncryptionConstants.ALLOW_MODIFY_CONTENTS
                        | EncryptionConstants.ALLOW_PRINTING | EncryptionConstants.ALLOW_SCREENREADERS, EncryptionConstants.DO_NOT_ENCRYPT_METADATA);
                    PdfEncryptor.Encrypt(reader, output, myProperties, null);
                    return new OkObjectResult(output.ToArray());
                }
            }
        }
    }
}

