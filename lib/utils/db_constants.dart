const String DB_NAME = "toDo.db";
const String TABLE_MAIN = "tableToDo";
const String COL_ID = "id";
const String COL_NAME = "itemName";
const String COL_CREATED = "dateCreated";
const String COL_MODIFIED = "dateModified";
const String COL_DONE = "isDone";

final String QUERY_CREATE_MAIN =
    "CREATE TABLE $TABLE_MAIN($COL_ID INTEGER PRIMARY KEY, $COL_NAME TEXT, $COL_CREATED TEXT, $COL_MODIFIED TEXT, $COL_DONE INTEGER)";
final String SELECT_ALL_MAIN =
    "SELECT * FROM $TABLE_MAIN ORDER BY $COL_DONE ASC";
final String SELECT_ALL_MAIN_COUNT = "SELECT COUNT(*) FROM $TABLE_MAIN";

final String GET_USER = "SELECT * FROM $TABLE_MAIN WHERE $COL_ID = ";
final String GET_SPECIFIC = "SELECT * FROM $TABLE_MAIN WHERE $COL_DONE = ";
//  static final String DELETE_USER = "SELECT * FROM $TABLE_MAIN WHERE $COL_ID = ";
