#########################################
# DEPENDENCIES:
#########################################
from splinter import Browser
from bs4 import BeautifulSoup
import time
import pandas as pd


#########################################
# FUNCTION TO INITIALIZE BROWSER USING CHROME DRIVER 
# - PLEASE MAKE SURE YOUR CHROMEDRIVER IS LOCATED IN THE SAME FOLDER
#########################################
def init_browser():
    executable_path = {"executable_path": "chromedriver"}
    return Browser("chrome", **executable_path, headless=True)


#########################################
# FUNCTION TO SCRAPE THE PREDEFINED WEBSITES 
#########################################
def scrape():

    # Define Variables:
    #####################################################################################
    # Nasa Data:
    nasa_url = "https://mars.nasa.gov/news/"
    nasa_dict = {
        "news_title": "",
        "news_p": ""
    }

    # JPL Data:
    jpl_url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    featured_image_url = ""

    # Mars Facts:
    mfact_url = "https://space-facts.com/mars/"

    # Mars Hemisphere Data:
    mhemi_url = "https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars"
    hemisphere_image_urls = []

    
    
    # Initialize browser:
    #####################################################################################
    browser = init_browser()



    # Nasa Data Scraping:
    #####################################################################################
    browser.visit(nasa_url)

    time.sleep(1)

    html = browser.html
    soup = BeautifulSoup(html, "html.parser")

    nasa_dict["news_title"] = soup.find("div", class_="content_title").get_text()
    nasa_dict["news_p"] = soup.find("div", class_="article_teaser_body").get_text()



    # JPL Data Scraping:
    #####################################################################################
    browser.visit(jpl_url)

    time.sleep(1)

    html = browser.html
    soup = BeautifulSoup(html, "html.parser")

    results = soup.find("div", class_="carousel_items").find("article")["style"] 
    ending_url_list = results.split("'")

    base_url = "https://www.jpl.nasa.gov"

    featured_image_url = base_url + ending_url_list[1]
    


    # Mars Facts Data Scraping:
    #####################################################################################
    # Use PANDAS to scrape:
    tableslist = pd.read_html(mfact_url)

    table_df = tableslist[1]

    # if necessary: named the columns:
    final_table_df = table_df.rename(columns={
        0: 'fact',
        1: 'value'
    })

    # Use PANDAS to convert data to HTML table string: 
    html_table = final_table_df.to_html(index=False)
    html_table.replace('\n', '')



    # Mars Hemisphere Data Scraping:
    #####################################################################################
    browser.visit(mhemi_url)

    time.sleep(1)

    html = browser.html
    soup = BeautifulSoup(html, "html.parser")

    linkresults = soup.find_all('a', class_='itemLink')

    #################################
    # Pull out the image partial links and their titles:
    #################################
    for x in linkresults:
        
        raw_title = x.find('img')
        link = x['href']
        
        if raw_title and link:
            title = raw_title['alt']
            final_title = title.replace(" Enhanced thumbnail", "")
            
            # click on the link to retrieve the the full res image url:
            browser.click_link_by_partial_text(final_title)
            time.sleep(1)
            html2 = browser.html
            soup2 = BeautifulSoup(html2, "html.parser")
            
            
            newresults = soup2.find_all('a')
            # loop through the a tags to find the right link:
            for hemi in newresults:
                if hemi.text == 'Sample':
                    newlink = hemi['href']
                    
    
            #Use a Python dictionary to store the data using the keys img_url and title:
            temp_dict = {
                "title": final_title,
                "img_url": newlink
            }
    
            # Append the dictionary with the image url string and the hemisphere title to a list
            hemisphere_image_urls.append(temp_dict)
    
    

 
    # Quite the browser after scraping
    #####################################################################################
    browser.quit()

    
    mars_dict = {
        "nasa" : nasa_dict,
        "jpl" : featured_image_url,
        "mfacts" : html_table,
        "mhemi" : hemisphere_image_urls
    }
    

    # Return results
    #####################################################################################
    return mars_dict

    




