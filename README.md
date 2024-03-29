# Trabajo Final Integrador - INCLUIT

## Lineamientos generales del proyecto


![Diagrama Ejercicio Integrador](/diagrama_ejercicio_integrador.png)

- El proyecto utiliza la suite de truffle.

- El código del proyecto está formateado conforme estándares recomendados por solidity.

- Los contratos cuentan con sus unit tests (10 Unit Tests en el contrato Manager.sol, y 6 Unit Tests en el contrato Ticket.sol), intentando cubrir el mayor coverage posible.

- El proyecto cuenta con una migration.

- El proyecto se encuentra deployado en la testnet de Goerli (https://goerli.etherscan.io/tx/0xc9f8ed9df2e2e2be32c6e6d5696532fdb5351fadccf2eccbb3ccf966c7b54a9e).

- Opcional: agregar algún script para ejecutar (Está agregado en la respectiva carpeta).

- Opcional: El proyecto debería usar algún estándar ERC.


# Caso de uso

Los directivos de una empresa local encargada de vender entradas a eventos están buscando competir de lleno en el mundo blockchain. Para eso planean desarrollar una aplicación para gestionar directamente en la testnet goerli los tickets y entradas a diferentes tipos de eventos. 
El MVP (minimum viable product), está orientado a buscar que los compradores que ya tienen sus tickets los puedan “tokenizar” y crear tickets virtuales dentro de la plataforma. De esta manera se diseñó lo siguiente: 

El proyecto deber estar estructurado con un contrato Manager y un contrato Ticket. Las responsabilidades de cada uno son las siguientes: 

### Manager

- Deberá tener una función para “tokenizar” un ticket. Esto significa crear un nuevo **Ticket** con los datos correspondientes. 

- Deberá tener una función para ver todos los tickets que contiene la plataforma, sin importar quien sea el dueño.

- Deberá tener una función para ver los tickets que están asignados a un dueño particular (address).

- Deberá tener una función para permitir la transferencia de un ticket según su estado, es decir que si un Ticket tiene un estado Transferible, puede cambiar de dueño. Permitiendo que el nuevo dueño envíe ethers a través de la plataforma y que el dueño anterior reciba esos ethers. 

- Deberá tener una función para permitir que el dueño de un ticket pueda cambiar el precio del mismo, pero en ese caso el contrato Manager cobra un 5% de comisión y queda en su balance.

- Deberá tener una función para retornar la cantidad de tickets que tiene la plataforma y el precio total de los tickets. Esto está pensado para mostrar estadísticas y poder llamar la atención de futuros inversores.

- Deberá tener una función para eliminar el ticket de la lista. 


### Ticket

El proceso de “tokenización” simplemente es recibir los datos del ticket por parámetros en el constructor.

- Los atributos del contrato Ticket son:     
  - **id**: Un identificador único para cada ticket.
  - **eventName**: El nombre del evento.
  - **eventDate**: La fecha del evento.
  - **price**: el precio en ethers del ticket.
  - **eventDescription**: Una descripción corta del evento.
  - **eventType**: el tipo de evento, en la v1 los tipos son Sports, Music, Cinema.
  - **status**: el estado del ticket, en la v1 los estados son: Used, Valid, Expired.
  - **transferStatus**: indica si es transferible o no, los estados son: Transferible, NoTransferible.
  - **owner**: el address que es dueño del ticket.

- Deberá tener una función para poder cambiar el precio del **Ticket**.

- Deberá tener una función para cambiar el estado de TransferStatus.

- Deberá tener una función para cambiar el estado del **Ticket** (status).

- Deberá tener una función para cambiar de dueño en caso de ser vendido.

- Deberá tener una función para generar el id único (hash).

- Deberá tener una función que retorne los datos relevantes del ticket, para poder mostrarlo (eventName, eventDate, price, eventDescription, eventType y status).

## Aspectos y validaciones a tener en cuenta

- Es importante que las acciones más importantes emitan eventos para poder verlos de manera clara del lado del cliente.

- Cualquier usuario debería poder ver la lista de tickets y podría crear nuevos tickets.

- Solamente el owner o admin del contrato **Manager** puede transferir un ticket de un dueño a otro.

- Solamente el owner o admin del contrato **Manager** puede cambiar el precio del mismo. 

- El address que interactúe con el contrato **Manager** para “tokenizar” un ticket, queda como owner del ticket. 

- eventType, status y transferStatus deberan ser enums y pueden estar en otro archivo o dentro del mismo contrato Ticket.
