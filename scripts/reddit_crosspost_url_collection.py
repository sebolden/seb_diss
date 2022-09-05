# -*- coding: utf-8 -*-
"""
Created on Sat Aug 27 23:24:09 2022

@author: ztacheva
"""

import os
import glob
import pandas as pd
os.chdir("C:\\Apps-SU")

import time
import numpy as np
import re
from parsel import Selector

 
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By 
from selenium.webdriver.support.ui import WebDriverWait 
from selenium.webdriver.support import expected_conditions as EC 
from selenium.common.exceptions import TimeoutException
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import StaleElementReferenceException
from bs4 import BeautifulSoup as soup
from selenium.webdriver import ActionChains



option = webdriver.ChromeOptions()
browser = webdriver.Chrome(executable_path='C:\\Apps-SU\\chromedriver_win32 (2)\\chromedriver', chrome_options=option)



url=[]
orig=[]
i=1

data=pd.read_csv("reddit_data-post_urls.csv")


for u in data.url:
 print(i)
 i=i+1
 address = u
 browser.get(address)
 time.sleep(2)
 try:
    button = browser.find_element_by_xpath("//*[contains(text(), 'View discussions in')]")
    button.click()
    time.sleep(4)
    #urls=browser.find_elements_by_xpath('//div[@class="_2FCtq-QzlfuN-SwVMUZMM3 t3_wsrb6r"]/a')
    urls=browser.find_elements_by_xpath('//div[@class="y8HYJ-y_lTUHkQIc1mdCq _2INHSNB8V5eaWp4P0rY_mE"]/a')
    for l in urls:
     url.append(l.get_attribute('href'))
     orig.append(u)
    
 except:
     url.append('na')
     orig.append(u)
     
     
     
df=pd.DataFrame(
    {'original_url':orig,
     'additional_url':url})


df.to_csv("discussion_urls.csv",index=False) 


                                                 