# Contexto del por qué de la implementación:

**Contexto:** La arquitectura se plantea bajo un problema bastante serio, al día de mañana la data que necesita la aplicación como usuarios y archivos no van a venir de la misma fuente de datos con la que se inició el proyecto, esto puede ser un problema porque tendríamos que hacer modificaciones a todos los providers, esto violenta a los principios de responsabilidad única, también se puede presentar un acoplamiento excesivo, violenta el principio de abierto cerrado ya que las clases, módulos y funciones deben estar abiertas para su extensión pero cerradas para su modificación, lo que priorizamos es que la aplicación no sufra muchos cambios cuando se quiera cambiar el modelo del dominio/ llamado a una nueva API.

Vamos a usar los *Repositorios y los DataSources*

**DataSources:** Es el lugar de dónde vamos a obtener los datos, donde es posible realizar los cambios de donde se van a extraer los datos sin necesidad de hacer muchos cambios en el código.

**Repositorio:** No vamos a tratar directamente el al origen de datos, el repositorio es el que va hablar al origen de datos que nosotros le digamos, el repositorio es quien va hablar al origen de datos que nosotros le digamos, cuando creamos el repo simplemente le vamos a enviar un origen de datos y el repositorio simplemente va a mandar a llamar los métodos que tenga el origen de datos.

# Ejemplos contextuales:

**Ejemplo:** tenemos muchos DataSources (1,2,..n) y para el repositorio es indiferente, porque ya va a saber qué métodos tiene qué puedo llamar, con qué argumentos, qué retorna. Es como una capa de protección que protege el código si el origen de datos 1 le cambió de nombre, por ejemplo de `id` a `uuid`

**Fácil de modificar, fácil de mantener, ya que se pueden presentar muchos cambios en el modelo del Dominio a lo largo del proyecto**

**Ejemplo de DataSources:** Pensemos en los **datasources** como los orígenes de datos de nuestra aplicación, es como en la universidad, donde tenemos diferentes profesores que dan diferentes clases... pero en sí, cada profesor sigue los lineamientos de la universidad para brindarles a ustedes las clases. **Cada profesor es un Datasource diferente**.

**Ejemplo de Repositorios:** Los **repositorios** son la forma en la que accedemos a los datasources, pensemos en el datasource como el aula de clase en si, cada profesor (**datasource**) entra al aula de clase, y empieza a enseñar matemáticas, filosofía, geografía, etc... luego el profesor (**datasource**) se va del salón, y entra otro nuevo profesor (**otro datasource**) pero hace exactamente lo mismo que el profesor anterior pero enseña otro tema.