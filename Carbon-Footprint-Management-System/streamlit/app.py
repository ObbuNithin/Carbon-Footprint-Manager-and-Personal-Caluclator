import PIL.Image
from PIL import Image
import pytesseract  # For extracting text from images
import os
from PyPDF2 import PdfReader  # For extracting text from PDFs
import google.generativeai as genai

# Initialize Google GenAI model
model = genai.GenerativeModel(model_name="gemini-1.5-pro")

def analyze_image(image_path, prompt):
    try:
        # Open the image and extract text (if any)
        image = Image.open(image_path)
        image_text = pytesseract.image_to_string(image)
        print(f"Extracted text from image: {image_text}")

        # Combine prompt and image text
        full_prompt = f"{prompt}\n\nExtracted text: {image_text}"

        # Generate content
        response = model.generate_content([full_prompt], generation_config=genai.GenerationConfig(
            max_output_tokens=1000,
            temperature=1,
        ))

        return response.text
    except Exception as e:
        return f"Error analyzing image: {e}"

def analyze_pdf(pdf_path, prompt):
    try:
        # Read PDF and extract text
        pdf_reader = PdfReader(pdf_path)
        pdf_text = ""
        for page in pdf_reader.pages:
            pdf_text += page.extract_text() + "\n"

        # Combine prompt and PDF text
        full_prompt = f"{prompt}\n\nExtracted text: {pdf_text}"

        # Generate content
        response = model.generate_content([full_prompt], generation_config=genai.GenerationConfig(
            max_output_tokens=1000,
            temperature=1,
        ))

        return response.text
    except Exception as e:
        return f"Error analyzing PDF: {e}"

# Example usage
image_path = "copilot.jpg"
pdf_path = "example.pdf"
prompt = ("Tell me what components of the file are useful or renewable, "
          "and by what percentage of the file? What examples of products can I make out of it? "
          "Are the products cost-effective?")

# Analyze image
image_analysis = analyze_image(image_path, prompt)
print("Image Analysis Result:")
print(image_analysis)

# Analyze PDF
pdf_analysis = analyze_pdf(pdf_path, prompt)
print("\nPDF Analysis Result:")
print(pdf_analysis)
