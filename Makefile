postgres:
	@docker run -itd --name tactical -p 5432:5432 postgres:latest

rm:
	@docker rm -f tactical
