## Paul Hager
## Native Transcription to Phoneme Transcription Script
## 7.7.15 -
## sbs_create_phntrans_UR.py

import string
import sys
import codecs

## Script should be run with the following options:
## python script.py <list of utterance IDs> <character to phoneme dictionary filename> <data directory>

def main(argv):
	utterance_list = argv[0]	
	char_to_phone_dict_filename = argv[1]
	data_dir = argv[2]

	utterance_list = open(utterance_list, 'r')
	char_to_phone_dict = open(char_to_phone_dict_filename, 'r')
	urdu_dict = {}
	phone_dict = {}
	dict_of_unknown = {}

	#Create a numeral to script dictionary	
	
	#Create a rough source language character to phoneme dictionary
	for line in char_to_phone_dict:
		items = line.split();
		phone_dict[unicode(items[0], encoding='utf-8')] = " ".join(items[1:])
	#print(phone_dict)
	#print
	
	for utterance in utterance_list:
		
		## Below line can be used when the list of utterances are the form XXXX.wav	
		#utterance_ID = utterance[:-5]

		## codecs code is borrowed from Spencer Green
		## See more at: http://www.spencegreen.com/2008/12/19/python-arabic-unicode/#sthash.BkRHT3pK.dpuf

		filename = data_dir + '/' + utterance_ID + '.txt'
		IN_FILE = codecs.open(filename,'r', encoding='utf-8')
		words = IN_FILE.readline().split()

		phone_tran_line = '' 

		for word in words:

			if word in urdu_dict.keys():
				phonemes = urdu_dict[word]
			else:
				phonemes = ''
				for character in word:
					if character not in phone_dict.keys():
						phonemes += '?' + ' '
					else:
						phonemes += phone_dict[character] + ' '			
				urdu_dict[word] = phonemes		

			final_word_phonemes = []
			init_word_phonemes = phonemes.split()
			
			# Standardizing eps -> SIL phoneme
			for phone in init_word_phonemes:
				if phone!='eps':
					final_word_phonemes.append(phone)
			final_word_phonetrans = ' '.join(final_word_phonemes)
			phone_tran_line = phone_tran_line + " " + final_word_phonetrans
		IN_FILE.close()
	
		sys.stdout.write(phone_tran_line + '\n')
	utterance_list.close()

if __name__ == "__main__":
	main(sys.argv[1:])
