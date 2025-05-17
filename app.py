# ########################################
# ########## SETUP

from flask import Flask, render_template, request, redirect
import database.db_connector as db

PORT = 58009

app = Flask(__name__)

# ########################################
# ########## ROUTE HANDLERS

# READ ROUTES
@app.route("/", methods=["GET"])
def home():
    try:
        return render_template("home.j2")

    except Exception as e:
        print(f"Error rendering page: {e}")
        return "An error occurred while rendering the page.", 500


@app.route("/bsg-people", methods=["GET"])
def bsg_people():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        # Create and execute our queries
        # In query1, we use a JOIN clause to display the names of the homeworlds,
        #       instead of just ID values
        query1 = "SELECT bsg_people.id, bsg_people.fname, bsg_people.lname, \
            bsg_planets.name AS 'homeworld', bsg_people.age FROM bsg_people \
            LEFT JOIN bsg_planets ON bsg_people.homeworld = bsg_planets.id;"
        query2 = "SELECT * FROM bsg_planets;"
        people = db.query(dbConnection, query1).fetchall()
        homeworlds = db.query(dbConnection, query2).fetchall()

        # Render the bsg-people.j2 file, and also send the renderer
        # a couple objects that contains bsg_people and bsg_homeworld information
        return render_template(
            "bsg-people.j2", people=people, homeworlds=homeworlds
        )
    
    except Exception as e:
        print(f"Error retrieving people: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()


@app.route("/Towns", methods=["GET"])
def db_towns():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        # Create and execute our queries
        query1 = "SELECT * FROM Towns;"
        towns = db.query(dbConnection, query1).fetchall()

        # Render the Towns.j2 file, and also send the renderer
        # an object that contains Towns information
        return render_template(
            "Towns.j2", towns=towns
        )
    
    except Exception as e:
        print(f"Error retrieving towns: {e}")
        return f"An error occurred while executing the database queries: {e}", 500

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route("/shops", methods=["GET"])
def db_shops():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        # Create and execute our queries
        query1 = "SELECT * FROM Shops;"
        shops = db.query(dbConnection, query1).fetchall()

        # Render the shops.j2 file and pass the shops data
        return render_template("shops.j2", shops=shops)

    except Exception as e:
        print(f"Error retrieving shops: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route("/quests", methods=["GET"])
def db_quests():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        # Query all quests
        query = "SELECT * FROM Quests;"
        quests = db.query(dbConnection, query).fetchall()

        # Render the quests.j2 file and pass the quests data
        return render_template("quests.j2", quests=quests)

    except Exception as e:
        print(f"Error retrieving quests: {e}")
        return "An error occurred while retrieving quests.", 500

    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()


@app.route("/town_quests", methods=["GET"])
def db_town_quests():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        # Query all town_quests
        query = "SELECT Town_Quests.Towns_TownID, Towns.TownName AS Town, Town_Quests.Quests_QuestID, Quests.QuestName AS Quest \
            FROM Town_Quests \
            JOIN Towns ON Town_Quests.Towns_TownID = Towns.TownID \
            JOIN Quests ON Town_Quests.Quests_QuestID = Quests.QuestID \
            ORDER BY Town_Quests.Towns_TownID ASC;"
        town_quests = db.query(dbConnection, query).fetchall()

        # Render the town_quests.j2 file and pass the town_quests data
        return render_template("town_quests.j2", town_quests=town_quests)

    except Exception as e:
        print(f"Error retrieving quests: {e}")
        return "An error occurred while retrieving town_quests.", 500

    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()


@app.route("/town_shops", methods=["GET"])
def db_town_shops():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        # Query all town_shops
        query = "SELECT Town_Shops.Towns_TownID, Towns.TownName AS Town, Town_Shops.Shops_ShopID, Shops.ShopName AS Shop \
            FROM Town_Shops \
            JOIN Towns ON Town_Shops.Towns_TownID = Towns.TownID \
            JOIN Shops ON Town_Shops.Shops_ShopID = Shops.ShopID \
            ORDER BY Town_Shops.Towns_TownID ASC;"
        town_shops = db.query(dbConnection, query).fetchall()

        # Render the town_shops.j2 file and pass the town_shops data
        return render_template("town_shops.j2", town_shops=town_shops)

    except Exception as e:
        print(f"Error retrieving quests: {e}")
        return "An error occurred while retrieving town_shops.", 500

    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()


@app.route("/poi", methods=["GET"])
def db_pois():
    try:
        dbConnection = db.connectDB()  # Open the database connection

        # Query all points of interest
        query = "SELECT * FROM Points_of_Interest;"
        pois = db.query(dbConnection, query).fetchall()

        # Render the points_of_interest.j2 file with POI data
        return render_template("poi.j2", pois=pois)

    except Exception as e:
        print(f"Error retrieving POIs: {e}")
        return "An error occurred while retrieving points of interest.", 500

    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

# Route for reset button
@app.route('/reset', methods=['POST'])
def reset_database():
    try:
        dbConnection = db.connectDB()  # Open the database connection
        
        # Create CALL query for the stored procedure
        query = "CALL sp_load_townsdb();"
        
        # Execute the query
        db.query(dbConnection, query)
        
        # Commit changes
        dbConnection.commit()
        
        # Redirect back to the home page
        return redirect("/")
        
    except Exception as e:
        print(f"Error resetting database: {e}")
        return f"An error occurred while resetting the database: {e}", 500
        
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

# Routes for deleting
@app.route('/delete_poi', methods=['POST'])
def delete_poi():
    try:
        dbConnection = db.connectDB()  # Open the database connection
        
        # Get the POI ID from the form
        poi_id = request.form.get('delete_poi_id')
        
        # Create DELETE query
        query = f"DELETE FROM Points_of_Interest WHERE POIID = {poi_id};"
        
        # Execute the query
        db.query(dbConnection, query)
        
        # Commit changes
        dbConnection.commit()
        
        # Redirect back to the POI page
        return redirect("/poi")
        
    except Exception as e:
        print(f"Error deleting POI: {e}")
        return f"An error occurred while deleting the point of interest: {e}", 500
        
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route('/delete_quest', methods=['POST'])
def delete_quest():
    try:
        dbConnection = db.connectDB()  # Open the database connection
        
        # Get the Quest ID from the form
        quest_id = request.form.get('delete_quest_id')
        
        # Create DELETE query
        query = f"DELETE FROM Quests WHERE QuestID = {quest_id};"
        
        # Execute the query
        db.query(dbConnection, query)
        
        # Commit changes
        dbConnection.commit()
        
        # Redirect back to the Quests page
        return redirect("/quests")
        
    except Exception as e:
        print(f"Error deleting Quest: {e}")
        return f"An error occurred while deleting the quest: {e}", 500
        
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route('/delete_shop', methods=['POST'])
def delete_shop():
    try:
        dbConnection = db.connectDB()  # Open the database connection
        
        # Get the Shop ID from the form
        shop_id = request.form.get('delete_shop_id')
        
        # Create DELETE query
        query = f"DELETE FROM Shops WHERE ShopID = {shop_id};"
        
        # Execute the query
        db.query(dbConnection, query)
        
        # Commit changes
        dbConnection.commit()
        
        # Redirect back to the Shops page
        return redirect("/shops")
        
    except Exception as e:
        print(f"Error deleting Shop: {e}")
        return f"An error occurred while deleting the shop: {e}", 500
        
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route('/delete_town', methods=['POST'])
def delete_town():
    try:
        dbConnection = db.connectDB()  # Open the database connection
        
        # Get the Town ID from the form
        town_id = request.form.get('delete_town_id')
        
        # Create DELETE query
        query = f"DELETE FROM Towns WHERE TownID = {town_id};"
        
        # Execute the query
        db.query(dbConnection, query)
        
        # Commit changes
        dbConnection.commit()
        
        # Redirect back to the Towns page
        return redirect("/Towns")
        
    except Exception as e:
        print(f"Error deleting Town: {e}")
        return f"An error occurred while deleting the town: {e}", 500
        
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route('/delete_town_quest', methods=['POST'])
def delete_town_quest():
    try:
        dbConnection = db.connectDB()  # Open the database connection
        
        # Get the Town ID and Quest ID from the form
        town_id = request.form.get('delete_town_id')
        quest_id = request.form.get('delete_quest_id')
        
        # Create DELETE query - here we need both IDs since this is an intersection table
        query = f"DELETE FROM Town_Quests WHERE Towns_TownID = {town_id} AND Quests_QuestID = {quest_id};"
        
        # Execute the query
        db.query(dbConnection, query)
        
        # Commit changes
        dbConnection.commit()
        
        # Redirect back to the Town_Quests page
        return redirect("/town_quests")
        
    except Exception as e:
        print(f"Error deleting Town-Quest relationship: {e}")
        return f"An error occurred while deleting the town-quest relationship: {e}", 500
        
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route('/delete_town_shop', methods=['POST'])
def delete_town_shop():
    try:
        dbConnection = db.connectDB()  # Open the database connection
        
        # Get the Town ID and Shop ID from the form
        town_id = request.form.get('delete_town_id')
        shop_id = request.form.get('delete_shop_id')
        
        # Create DELETE query - here we need both IDs since this is an intersection table
        query = f"DELETE FROM Town_Shops WHERE Towns_TownID = {town_id} AND Shops_ShopID = {shop_id};"
        
        # Execute the query
        db.query(dbConnection, query)
        
        # Commit changes
        dbConnection.commit()
        
        # Redirect back to the Town_Shops page
        return redirect("/town_shops")
        
    except Exception as e:
        print(f"Error deleting Town-Shop relationship: {e}")
        return f"An error occurred while deleting the town-shop relationship: {e}", 500
        
    finally:
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

# ########################################
# ########## LISTENER

if __name__ == "__main__":
    app.run(
        port=PORT, debug=True
    )  # debug is an optional parameter. Behaves like nodemon in Node.