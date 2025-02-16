# Danny's Diner Case Study 🍣🍛🍜

## 📖 Overview
This case study, **"Danny's Diner"**, focuses on helping Danny understand his customers' dining behaviors. The analysis spans various insights, from total spending to favorite items, in an effort to build a better loyalty program. 
This project is based on a fictional scenario designed by [Danny Ma](https://www.linkedin.com/in/datawithdanny/) as part of the 8-Week SQL Challenge.

**Objective**: To analyze customer behavior and purchasing patterns to support business and loyalty program decisions.

## 🗂️ Project Structure
- **`SQL_Solutions.sql`**: All SQL answers to the case study questions, presented in a single file.
- **`Schema_Setup.sql`**: SQL setup file containing schema and initial table creation for the `sales`, `menu`, and `members` tables.
- **`README.md`**: Provides project context, setup instructions, and case study question descriptions.

## 📊 Case Study Questions
The following questions were analyzed and answered in this project:
1. **Total spending per customer**: What is the total amount each customer spent?
2. **Visit frequency**: How many days has each customer visited?
3. **First purchased item**: What was the first item from the menu each customer purchased?
4. **Most popular item**: What is the most purchased item across all customers?
5. **Customer-specific favorites**: Which item is most popular for each customer?
6. **First purchase post-membership**: What item was bought first after becoming a member?
7. **Last purchase pre-membership**: What was the last item bought before joining the loyalty program?
8. **Spending before membership**: Total items and amount spent by each member before joining.
9. **Points calculation**: Points earned by each customer based on spending, with `sushi` having a 2x multiplier.
10. **Points within loyalty week**: Double points earned by customers in the first week of membership, on all items.
11. **Bonus Questions**:
    - **Join All Tables**: Merging all tables to display complete purchase data.
    - **Rank Customer Purchases**: Ranking customer purchases with null values for non-members.

## 🔍 Sample Data
Danny provided sample datasets for analysis, located in the `Data/` folder.

**sales.csv**:
| customer_id | order_date | product_id |
| ----------- | ---------- | ---------- |
| A           | 2021-01-01 | 1          |
| ...         | ...        | ...        |

**menu.csv**:
| product_id | product_name | price |
| ---------- | ------------ | ----- |
| 1          | sushi        | 10    |
| ...        | ...          | ...   |

**members.csv**:
| customer_id | join_date   |
| ----------- | ----------- |
| A           | 2021-01-07  |
| ...         | ...         |

## 📝 Analysis Highlights
- **Question 1**: The total amount each customer spent is calculated using the `SUM(price)` function after joining sales and menu tables.
- **Question 9**: Points are calculated with `10 points per $1 spent`, with a `2x multiplier` applied for sushi.

Additional insights on specific questions are provided in `SQL_Solutions.sql`.

## 🚀 Usage
1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/Dannys_Diner_Case_Study.git
    cd Dannys_Diner_Case_Study
    ```
2. **Database Setup**:
    - Load the `Schema_Setup.sql` file into your SQL environment to create the Schema structure in your Database.
    - If you Didn't created Database plz do so first
    -  ```CREATE DATABASE your_database_name;
3. **Running Queries**:
    - Open `SQL_Solutions.sql` in your preferred SQL editor and run queries to view answers to each question.

---

## 🤝 Contributing
Feel free to submit pull requests to improve or add additional insights to this case study.

## 📄 License
This project is licensed under the MIT License.
