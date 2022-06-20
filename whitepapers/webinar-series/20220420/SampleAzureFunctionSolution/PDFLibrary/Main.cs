using System.Collections.Immutable;
using System.IO;
using System.Linq;
using ImmutableClassLibrary;
using iText.Forms;
using iText.Forms.Fields;
using iText.Kernel.Pdf;


namespace PDFLibrary
{
    public class PdfMethods

    {
        //Write a  PDF  
        public static ImmutableArray<byte> Write(ImmutableString path, ImmutableArray<byte> bytes)
        {
            File.WriteAllBytes(path.Value, bytes.ToArray());

            return Read(path);
        }
        
        //Read a PDF
        public static ImmutableArray<byte> Read(ImmutableString path)
        {
            return  ImmutableArray.Create<byte>(File.ReadAllBytes(path.Value));
        }

        //Determine if a file is a PDF
        public static ImmutableBoolean IsPDF(ImmutableArray<byte> file)
        {

                using (var ms = new MemoryStream(file.ToArray()))
                {
                    using (var reader = new PdfReader(ms))
                    {
                        return new ImmutableBoolean(true);
                    }
                }

        }


        //Get a list of fields in a PDF
        public static ImmutableArray<string> Fields(ImmutableArray<byte> pdf)
        {

            return getFormFields(pdf).Keys.ToArray().ToImmutableArray();
        }


        //Get field data from a PDF
        public static ImmutableDictionary<string,string>  GetData(ImmutableArray<byte> pdf)
        {
            return getFormFields(pdf).ToDictionary(x => x.Key, x => x.Value.GetValueAsString()).ToImmutableDictionary();
        }

        //Set field data in a PDF
        public static ImmutableArray<byte> SetData(ImmutableArray<PdfField>  fields, ImmutableArray<byte> pdf)
        {
            using (var ms = new MemoryStream())
            {
                using (var doc = new PdfDocument(new PdfReader(new MemoryStream(pdf.ToArray())), new PdfWriter(ms)))

                {
                    var form = PdfAcroForm.GetAcroForm(doc,false);
                    var formFields = form.GetFormFields();
                    foreach (var field in fields)
                    {
                        if (string.IsNullOrEmpty(field.DisplayValue))
                        {
                            formFields[field.Name].SetValue(field.Value);
                        }
                        else
                        {
                            formFields[field.Name].SetValue(field.Value, field.DisplayValue);
                        }
                    }

                    doc.Close();
                    return   ImmutableArray.Create<byte>(ms.ToArray());
                }
            }
        }

        static ImmutableDictionary<string, PdfFormField> getFormFields(ImmutableArray<byte> pdf)
        {
            using (var ms = new MemoryStream(pdf.ToArray()))
            {
                using (var reader = new PdfReader(ms))
                {
                    using (var doc = new PdfDocument(reader))
                    {
                        var builder = ImmutableDictionary
                            .CreateBuilder<string, PdfFormField>();


                        PdfAcroForm.GetAcroForm(doc, false)
                            .GetFormFields().ToList()
                            .ForEach(x => builder.Add(x.Key, x.Value));

                        return builder.ToImmutable();
                    }
                }
            }
        }
    }


    //PDF Field Object to hold name, value, and display value
    public class PdfField
    {
        public PdfField(string name, string value, string displayValue = null)
        {
            DisplayValue = displayValue;
            Value = value;
            Name = name;
        }

        public string Name { get; }
        public string Value { get; }
        public string DisplayValue { get; }
    }
}