using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text.Json;
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
    
    public static class FillPDF
    {
        [FunctionName("FillPDF")]
        [OpenApiOperation(operationId: "Run", tags: new[] { "name" })]
        [OpenApiSecurity("function_key", SecuritySchemeType.ApiKey, Name = "code", In = OpenApiSecurityLocationType.Query)]
        [OpenApiParameter(name: "name", In = ParameterLocation.Query, Required = true, Type = typeof(string), Description = "The **Name** parameter")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "text/plain", bodyType: typeof(string), Description = "The OK response")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            foreach (var dataItem in data)
            {
                var dataItemValue = dataItem.Value;
            }
            var mapping = req.Form["mapping"];
            //log.LogInformation(req.Body.ToString());
            //var formdata = req.Form; //await req.ReadFormAsync();
            
            //string mapping = formdata["mapping"];
            //JsonDocument mappingDoc = JsonDocument.Parse(mapping);
            //Stream bodyStream = req.Body;

            //Stream pdfForm = req.Body;
            Stream pdfForm = req.Form.Files["file"].OpenReadStream();
            
            MemoryStream workstream = new MemoryStream();
            PdfWriter writer = new PdfWriter(workstream);
            PdfDocument pdfDoc = new PdfDocument(new PdfReader(pdfForm), writer);
            writer.SetCloseStream(false);
            PdfAcroForm form = PdfAcroForm.GetAcroForm(pdfDoc, true);
            var formFields = form.GetFormFields();

            //dynamic dynJson = JsonConvert.DeserializeObject(formdata["mapping"]);
            //dynamic dynJson = JsonConvert.DeserializeObject(req.Form["mapping"]);
            var mappingList = JsonConvert.DeserializeObject<List<MappingItem>>(req.Form["mapping"]);
            foreach (var item in mappingList)
            {
                var fieldname = item.fieldname;
                var fieldvalue = item.fieldvalue;
                formFields[fieldname].SetValue(fieldvalue);
            }

            //foreach (var item in dynJson)
            //{
            //    var fieldname = item.fieldname;
            //    var fieldvalue = item.fieldvalue;
            //    //formFields[item.fieldname].SetValue(item.fieldvalue);
            //}


            //foreach (var field in formFields)
            //{
            //    formFields[field.Key].SetValue("Dave");
            //}

            pdfDoc.Close();
            workstream.Position = 0;

            return new OkObjectResult(workstream);

        }
    }
}

