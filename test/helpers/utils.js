//Colocamos funciones que vamos a utilizar en diversos tests y contratos
//Para reutilizar codigo

async function shouldThrow(promise) {
    //le pasamos una funcion y la debe ejecutar (promise)
    //en caso que si pueda, devuelve que esta ok (assert(true))
    try {
      await promise;
      assert(true);
    }
    //en caso de error, no ejecuta el assert y va al otro assert(false)
    catch (err) {
      return;
    }
    assert(false, "The contract did not throw");
  }
  
  module.exports = {
    shouldThrow,
  };