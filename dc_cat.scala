
import net.ogalab.datacell.h2.DcCat
import net.ogalab.datacell.

val dbName = "./df_test"
val facObj = new H2Factory
facObj.createDBIfAbsent(dbName)
val reader = new DataCellReader

reader.printRows(facObj, dbName, dataSet, predicate)
