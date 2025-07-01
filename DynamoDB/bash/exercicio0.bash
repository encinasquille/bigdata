#### -------------------------------------------------------------------------------
aws dynamodb create-table \
--table-name Music \
--attribute-definitions AttributeName=Artist,AttributeType=S AttributeName=SongTitle,AttributeType=S \
--key-schema AttributeName=Artist,KeyType=HASH AttributeName=SongTitle,KeyType=RANGE \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5


#### -------------------------------------------------------------------------------

aws dynamodb put-item --table-name Music --item '{"Artist": {"S": "The Beatles"}, "SongTitle": {"S": "Hey Jude"}}'

aws dynamodb put-item --table-name Music  --item '{"Artist": {"S": "Taylor Swift"}, "SongTitle": {"S": "Shake It Off"}, "AlbumTitle": {"S": "1989"}, "Year": {"N": "2014"}}'

aws dynamodb put-item --table-name Music  --item '{"Artist": {"S": "Red Hot Chili Peppers"}, "SongTitle": {"S": "Californication"}, "Genres": {"SS": ["Alternative Rock", "Funk Rock"]}}'

aws dynamodb put-item --table-name Music  --item '{"Artist": {"S": "Bob Dylan"}, "SongTitle": {"S": "Like a Rolling Stone"}, "AlbumTitle": {"S": "Highway 61 Revisited"}, "Year": {"N": "1965"}}'

#### -------------------------------------------------------------------------------

aws dynamodb scan --table-name Music 

#### -------------------------------------------------------------------------------

aws dynamodb get-item --table-name Music --key '{"Artist": {"S": "Bob Dylan"}, "SongTitle": {"S": "Like a Rolling Stone"}}'

aws dynamodb get-item --table-name Music --key '{"Artist": {"S": "The Beatles"}, "SongTitle": {"S": "Hey Jude"}}'

## este abaixo nao iria funciona, porque 'Year' eh palavra reservada do DynamoDB
aws dynamodb get-item --table-name Music --key '{"Artist": {"S": "Taylor Swift"}, "SongTitle": {"S": "Shake It Off"}}' --projection-expression "AlbumTitle, Year"

## resolver assim usando expression-atribute-names
aws dynamodb get-item --table-name Music --key '{"Artist": {"S": "Taylor Swift"}, "SongTitle": {"S": "Shake It Off"}}' --projection-expression "AlbumTitle, #Y" --expression-attribute-names '{"#Y":"Year"}'

#### -------------------------------------------------------------------------------
#### update

aws dynamodb update-item \
    --table-name Music \
    --key '{ "Artist": {"S": "Taylor Swift"}, "SongTitle": {"S": "Shake It Off"} }' \
    --update-expression "SET #yr = :newYear" \
    --condition-expression "#yr = :oldYear" \
    --expression-attribute-names '{"#yr": "Year"}' \
    --expression-attribute-values '{ ":oldYear": {"N": "2014"}, ":newYear": {"N": "2015"} }' \
    --return-consumed-capacity TOTAL

##delete


aws dynamodb delete-item --table-name Music --key '{"Artist": {"S": "Taylor Swift"}, "SongTitle": {"S": "Shake It Off"}}' 


#### -------------------------- PARTIQL--------------------------------------------


aws dynamodb execute-statement --statement "INSERT INTO Music VALUE  \
 {'Artist':'No One You Know','SongTitle':'Call Me Today', 'AlbumTitle':'Somewhat Famous', 'Awards':'1'}"

aws dynamodb execute-statement --statement "INSERT INTO Music  VALUE  \
 {'Artist':'No One You Know','SongTitle':'Howdy', 'AlbumTitle':'Somewhat Famous', 'Awards':'2'}"

aws dynamodb execute-statement --statement "INSERT INTO Music VALUE  \
 {'Artist':'Acme Band','SongTitle':'Happy Day', 'AlbumTitle':'Songs About Life', 'Awards':'10'}" 

aws dynamodb execute-statement --statement "INSERT INTO Music  VALUE  \
  {'Artist':'Acme Band','SongTitle':'PartiQL Rocks', 'AlbumTitle':'Another Album Title', 'Awards':'8'}"

aws dynamodb execute-statement \
--statement "INSERT INTO Music VALUE {'Artist':'Acme Band','SongTitle':'PartiQL Rocks'}"

#### -------------------------------------------------------------------------------
aws dynamodb execute-statement \
--statement "SELECT * FROM Music WHERE Artist='Acme Band' AND SongTitle='PartiQL Rocks'"



#### -------------------------------------------------------------------------------
aws dynamodb execute-statement \
--statement "UPDATE Music SET AwardsWon=1  \
             SET AwardDetail={'Grammys':[2020, 2018]}  \
   WHERE Artist='Acme Band' AND SongTitle='PartiQL Rocks'"


aws dynamodb execute-statement \
--statement "UPDATE Music  \
            SET BandMembers =<<'Fredy Mercurio', 'Joao Deacon'>>  \
            WHERE Artist='Acme Band' AND SongTitle='PartiQL Rocks'"


#### -------------------------------------------------------------------------------


aws dynamodb execute-statement \
--statement  "DELETE  FROM Music  \
    WHERE Artist='Acme Band' AND SongTitle='PartiQL Rocks'"

#### -------------------------------------------------------------------------------

#### --------------------------- DELETE ---------------------------------------

aws dynamodb delete-table --table-name Music 

#### -------------------------------------------------------------------------------
