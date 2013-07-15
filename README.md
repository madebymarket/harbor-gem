# Harbor (open beta)

This gem is a cli interface for the file Harbor file transfer service (https://harbor.madebymarket.com).  It allows you to quickly and easily upload files to Harbor and notify people -- like emailing the files only better because everyone on the planet hates 1M+ attachments.  Simply harbor your files to the person and in a couple seconds they'll get direct download links in their inbox.  Huzzah!

## Uploading files

For now, the cli allows you to upload files quickly and gives you back an s3 url to your file.  We are quickly adding more features that will allow you to batch uploads and send notifications through the client, but for now you should use the website if you want to be able to enter a list of recipients who should get your download URLs for a batch of files. 

### Encrypted uploads

We are experimenting with in-browser client-side encryption, but we all know that there are serious flaws with that approach and it would not be easy to trust.  Instead, we suggest that you upload your files using gpg and use the harbor gem to upload the encrypted version.  It is very quick and easy, just download the GPG Tools from https://gpgtools.org/ and generate a key for your email address.

#### Encrypting for a specific recipient

The simplest way to do this is to get the public gpg key for the people you expect to need to decrypt your file.  The easiest way to do this is to use the GPG Keychain app to find a key for their email address.  If they don't have a public key published, they should go ahead and generate one real fast and add it to the database.

Now, to the fun part:

		$ gpg --encrypt -o your-encrypted-file.txt.gpg passwords.txt

		# now, you'll get a short series of prompts asking who should be able to decrypt this file.  Enter your own
		# email address first if you expect to need to decrypt the file at some point, then hit enter.
		> Enter the user ID.  End with an empty line: bryan@madebymarket.com
		
		# You'll see a bit of output with yourself listed as a recipient of the file.  Now you can go ahead and enter
		# the other people who should be able to decrypt this file.  Type their email address and hit enter, when
		# you're finished with that, hit enter and it'll go on and it'll kick out your encrypted file.

		# now you'll have a file called your-encrypted-file.txt.gpg -- just throw that file into Harbor and give
		# the link out to people who need to download & decrypt it.

		$ harbor --file your-encrypted-file.txt.gpg

#### Decrypting files with your key

This is super simple, especailly with the GPG Tools.  With your encrypted file, you just do:

    $ gpg --decrypt -o unencrypted-file.txt your-encrypted-file.txt.gpg

#### Encrypting files with a pass phrase

If you want to encrypt a file with a password and don't want to go through all of that key business, simply do:

		$ gpg -o encrypted.txt.gpg --symmetric passwords.txt
		# It will ask you for a password to use to encrypt it and then it'll kick out a file called encrypted.txt.gpg
		# just like above, toss that file at Harbor and it'll give you a download link to share.

		$ harbor --file encrypted.txt.gpg
	
#### Decrypting files with pass phrases

		$ gpg --decrypt -o passwords.txt passwords.txt.gpg
		# it'll prompt you for the password used to encrypt the file, then it'll spit out a passwords.txt file. 

## Signing up

Harbor accounts are completely free for transferring files under 1M, and we have monthly plans to fit any budget.  We welcome any input and would happily try to tailer a plain to your needs.  You can sign up on the website, or through the gem:

		$ gem install harborapp
    $ harbor signup

You'll receive an email with a link to confirm your account.  You know the drill. 

## Logging in

You can log in and use Harbor from the website or through the gem.  The gem will also include helper methods that you can use to extend Harbor functionality to your application, however, those features are on our long-term roadmap and are not yet available publicly.  If you're interested in being a part of our test group for new things, please shout.  

    $ harbor login

## Contributing

We welcome any pull requests, issue/bug reports, and feature requests.  Tweet us @madebymarket 
