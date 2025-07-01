#### -------------------------------------------------------------------------------
## se o link nao funcionar mais, eh so descarregar as pastas de exemplo1 e exemplo2
git clone https://github.com/machicao/eEDB-016-PECE.git

## por conveniencia movemos as pastas
mv eEDB-016-PECE/exemplo1 exemplo1
mv eEDB-016-PECE/exemplo2 exemplo2
#### -------------------------------------------------------------------------------
aws dynamodb create-table \
    --table-name ProductCatalog \
    --attribute-definitions AttributeName=Id,AttributeType=N \
    --key-schema AttributeName=Id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=10,WriteCapacityUnits=5


#### -------------------------------------------------------------------------------

aws dynamodb batch-write-item --request-items file://exemplo1/ProductCatalog.json


#### -------------------------------------------------------------------------------
aws dynamodb scan --table-name ProductCatalog


#### -------------------------------------------------------------------------------
aws dynamodb get-item \
    --table-name ProductCatalog \
    --key '{"Id":{"N":"101"}}'


aws dynamodb get-item \
    --table-name ProductCatalog \
    --key '{"Id":{"N":"101"}}' \
    --projection-expression "ProductCategory, Price, Title" \
    --return-consumed-capacity TOTAL



aws dynamodb get-item \
    --table-name ProductCatalog \
    --key '{"Id":{"N":"101"}}' \
    --consistent-read \
    --projection-expression "ProductCategory, Price, Title" \
    --return-consumed-capacity TOTAL


#### -------------------------------------------------------------------------------


aws dynamodb update-item \
    --table-name ProductCatalog \
    --key '{
        "Id" : {"N": "201"}
    }' \
    --update-expression "SET #Color = list_append(#Color, :values)" \
    --expression-attribute-names '{"#Color": "Color"}' \
    --expression-attribute-values '{
        ":values" : {"L": [{"S" : "Blue"}, {"S" : "Yellow"}]}
    }' \
    --return-consumed-capacity TOTAL

#### -------------------------------------------------------------------------------


aws dynamodb delete-table --table-name ProductCatalog
