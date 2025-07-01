#### -------------------------------------------------------------------------------
## se o link nao funcionar mais, eh so descarregar as pastas de exemplo1 e exemplo2
git clone https://github.com/machicao/eEDB-016-PECE.git

## por conveniencia movemos as pastas
mv eEDB-016-PECE/exemplo1 exemplo1
mv eEDB-016-PECE/exemplo2 exemplo2
#### -------------------------------------------------------------------------------

aws dynamodb create-table \
    --table-name Forum \
    --attribute-definitions \
        AttributeName=Nome,AttributeType=S \
    --key-schema \
        AttributeName=Nome,KeyType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=10,WriteCapacityUnits=5 && \

aws dynamodb wait table-exists --table-name Forum

aws dynamodb create-table \
    --table-name Thread \
    --attribute-definitions \
        AttributeName=NomeForum,AttributeType=S \
        AttributeName=Tema,AttributeType=S \
    --key-schema \
        AttributeName=NomeForum,KeyType=HASH \
        AttributeName=Tema,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=10,WriteCapacityUnits=5 && \

aws dynamodb wait table-exists --table-name Thread

aws dynamodb create-table \
    --table-name Resposta \
    --attribute-definitions \
        AttributeName=Id,AttributeType=S \
        AttributeName=DataResposta,AttributeType=S \
    --key-schema \
        AttributeName=Id,KeyType=HASH \
        AttributeName=DataResposta,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=10,WriteCapacityUnits=5 && \
 
aws dynamodb wait table-exists --table-name Resposta


#### -------------------------------------------------------------------------------


aws dynamodb batch-write-item --request-items file://exemplo2/Forum.json

aws dynamodb batch-write-item --request-items file://exemplo2/Thread.json

aws dynamodb batch-write-item --request-items file://exemplo2/Resposta.json

#### -------------------------------------------------------------------------------

aws dynamodb scan --table-name Resposta

aws dynamodb query \
    --table-name Resposta \
    --key-condition-expression 'Id = :Id' \
    --expression-attribute-values '{
        ":Id" : {"S": "Gatos#Gatos Topico 1"}
    }' \
    --return-consumed-capacity TOTAL


aws dynamodb query \
    --table-name Resposta \
    --key-condition-expression 'Id = :Id and DataResposta > :ts' \
    --expression-attribute-values '{
        ":Id" : {"S": "Gatos#Gatos Topico 1"},
        ":ts" : {"S": "2015-09-21"}
    }' \
    --return-consumed-capacity TOTAL


aws dynamodb query \
    --table-name Resposta \
    --key-condition-expression 'Id = :Id' \
    --filter-expression 'PostadoPor = :user' \
    --expression-attribute-values '{
        ":Id" : {"S": "Gatos#Gatos Topico 1"},
        ":user" : {"S": "Usuario B"}
    }' \
    --return-consumed-capacity TOTAL

#### ---------------------- DESAFIO -----------------------------------------------
##retornar apenas a primeira resposta a um tópico -  análogo em SQL a “ORDER BY ReplyDateTime ASC LIMIT 1”.

aws dynamodb query \
    --table-name Resposta \
    --key-condition-expression 'Id = :Id' \
    --expression-attribute-values '{
        ":Id" : {"S": "Gatos#Gatos Topico 1"}
    }' \
    --max-items 1 \
    --scan-index-forward  \
    --return-consumed-capacity TOTAL

##retornar apenas a resposta mais recente para um tópico - análogo de SQL para “ORDER BY ReplyDateTime DESC LIMIT 1”, 

aws dynamodb query \
    --table-name Resposta \
    --key-condition-expression 'Id = :Id' \
    --expression-attribute-values '{
        ":Id" : {"S": "Gatos#Gatos Topico 1"}
    }' \
    --max-items 1 \
    --no-scan-index-forward  \
    --return-consumed-capacity TOTAL

#### -------------------------------------------------------------------------------
#Atualizar

aws dynamodb update-item \
   --table-name Forum \
   --key '{"Nome" : {"S": "Gatos"}}' \
   --update-expression "SET Mensagem = :newMessages" \
   --condition-expression "Mensagem = :oldMessages" \
   --expression-attribute-values '{
        ":oldMessages" : {"N": "4"},
        ":newMessages" : {"N": "5"}
    }' \
   --return-consumed-capacity TOTAL


#remover item
aws dynamodb query \
   --table-name Resposta \
   --key-condition-expression 'Id = :Id'  \
   --expression-attribute-values '{
        ":Id" : {"S": "Gatos#Gatos Topico 1"}
    }'\
   --return-consumed-capacity TOTAL


#### -------------------------------------------------------------------------------
#### -------------------------------------------------------------------------------
#### -------------------------------------------------------------------------------
#### -------------------------------------------------------------------------------


aws dynamodb scan \
    --table-name Resposta \
    --filter-expression 'PostadoPor = :user' \
    --expression-attribute-values '{
        ":user" : {"S": "Usuario A"}
    }' \
    --return-consumed-capacity TOTAL



aws dynamodb scan \
    --table-name Resposta \
    --filter-expression 'PostadoPor = :user' \
    --expression-attribute-values '{
        ":user" : {"S": "Usuario A"}
    }' \
    --max-items 2 \
    --return-consumed-capacity TOTAL

## usa o último token produzido pelo scan anterior

aws dynamodb scan \
    --table-name Resposta \
    --filter-expression 'PostadoPor = :user' \
    --expression-attribute-values '{
        ":user" : {"S": "Usuario A"}
    }' \
    --max-items 2 \
    --starting-token eyJFeGNsdXNpdmVTdGFydEtleSI6IG51bGwsICJib3RvX3RydW5jYXRlX2Ftb3VudCI6IDJ9 \
    --return-consumed-capacity TOTAL



#### -------------------------------------------------------------------------------

aws dynamodb scan \
    --table-name Forum


aws dynamodb scan \
    --table-name Forum \
    --filter-expression 'Threads >= :threads AND Vistas >= :views' \
    --expression-attribute-values '{
        ":threads" : {"N": "1"},
        ":views" : {"N": "50"}
    }' \
    --return-consumed-capacity TOTAL


#### -------------------------------------------------------------------------------

#### -------------------------------------------------------------------------------
 

aws dynamodb delete-item \
    --table-name Resposta \
    --key '{
        "Id" : {"S": "Gatos#Gatos Topico 1"},
        "DataResposta" : {"S": "2015-09-15T19:58:22.947Z"}
    }'


#### -------------------------------------------------------------------------------

aws dynamodb put-item \
    --table-name Resposta \
    --item '{
        "Id" : {"S": "Cachorros#Cachorros Topico 2"},
        "DataResposta" : {"S": "2021-04-27T17:47:30Z"},
        "Mensagem" : {"S": "Cachorros Topico 2 Resposta 3 texto"},
        "PostadoPor" : {"S": "Usuario C"}
    }' \
    --return-consumed-capacity TOTAL


aws dynamodb delete-item \
    --table-name Resposta \
    --key '{
        "Id" : {"S": "Cachorros#Cachorros Topico 2"},
        "DataResposta" : {"S": "2021-04-27T17:47:30Z"}
    }'




