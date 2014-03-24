import os
import arff
from bs4 import BeautifulSoup
from random import randint

index = 0
infos = []

with open('train-urls.txt') as urls:
	cmd = 'rm index*'
	os.system(cmd)
	for url in urls:
		cmd = 'wget ' + url
		os.system(cmd)
		filename = ''
		if index == 0:
			filename = "index.html"
		else:
			filename = "index.html." + str(index)

		soup = BeautifulSoup(open("./" + filename))

		i=0
		for link in soup.find_all('a'):
			i = i+1

		link = False
		link10 = False
		link100 = False
		link1000 = False
		if i > 0:
			link = True
		if i > 10:
			link10 = True
		if i > 100:
			link100 = True
		if i > 1000:
			link1000 = True

		j=0
		for photo in soup.find_all('img'):
			j = j+1

		photo = False
		photo10 = False
		photo100 = False
		if j > 0:
			photo = True
		if j > 10:
			photo10 = True
		if j > 100:
			photo100 = True
		
		k=0
		for strong in soup.find_all('strong'):
			k = k+1
		for bold in soup.find_all('b'):
			k = k+1
		for em in soup.find_all('em'):
			k = k+1
		for italic in soup.find_all('i'):
			k = k+1

		hasEmphasis = False
		if k:
			hasEmphasis = True

		important = False
		if index < 146:
			important = True

		semiImportant1 = important
		semiImportant2 = important
		semiImportant3 = important
		semiImportant4 = important
		if randint(0,9) < 1:
			semiImportant1 = not important
		if randint(0,9) < 2:
			semiImportant2 = not important
		if randint(0,9) < 3:
			semiImportant3 = not important
		if randint(0,9) < 4:
			semiImportant4 = not important

		info = [link, link10, link100, link1000, photo, photo10, photo100, hasEmphasis, semiImportant1, semiImportant2, semiImportant3, semiImportant4, important]
		infos.append(info);
		index = index+1

arff.dump('./train.arff', infos, relation="webpage_info", names=['hasLinks', 'moreThan10Links', 'moreThan100Links', 'moreThan1000Links', 'hasPhotos', 'moreThan10Photos', 'moreThan100Photos', 'hasBoldOrItalic', 'semi-important1', 'semi-important2', 'semi-important3', 'semi-important4', 'important'])
