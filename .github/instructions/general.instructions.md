---
description: General project instructions and requirements for the Smart Travel Planner application
applyTo: "**"
---

# Smart Travel Planner - General Instructions

## Project Overview

Project Name: TravelMate Pro

A web application that helps users plan trips, manage travel budgets, track expenses, maintain travel checklists, and view travel reports.

---

## Tech Stack

Frontend:

- HTML5
- CSS3
- Vanilla JavaScript

Database:

- MySQL

---

## User Roles

### Traveler

- Register
- Login
- Logout
- Manage profile
- Create trips
- Track expenses
- Manage travel checklist
- View reports

### Admin

- Manage users
- Monitor trips
- Generate reports

---

## Features

### Authentication

- User Registration
- User Login
- User Logout
- Form Validation

### Trip Management

- Create Trip
- Edit Trip
- Delete Trip
- View Trip Details

Trip Details:

- Destination
- Start Date
- End Date
- Budget
- Hotel Name
- Transportation
- Notes

### Expense Tracking

- Add Expense
- Edit Expense
- Delete Expense
- View Expenses
- Budget vs Actual Spending

Expense Fields:

- Title
- Amount
- Category
- Date

### Travel Checklist

- Add Checklist Item
- Mark Item Complete
- Delete Item

### Reports and Analytics

- Total Trips
- Total Expenses
- Monthly Statistics
- Most Visited Destination
- Budget Utilization Summary

---

## Database Requirements

Tables:

- users
- trips
- destinations
- expenses
- checklist
- reports

Database Rules:

- Use Primary Keys
- Use Foreign Keys
- Follow Normalization
- Create Indexes where required
- Use meaningful names for tables and columns

SQL Concepts:

- SELECT
- INSERT
- UPDATE
- DELETE
- JOIN
- GROUP BY
- HAVING
- Views
- Stored Procedures
- Triggers

---

## UI Guidelines

Theme:
Modern Travel Planner

Requirements:

- Responsive Design
- Mobile First Layout
- Dashboard Cards
- Modern Navigation
- User-Friendly Forms
- Dark Mode Support

Color Palette:

Primary: #3498db

Secondary: #2ecc71

Accent: #f39c12

Background: #f5f7fa

Text: #2c3e50

---

## Coding Standards

HTML

- Use semantic HTML tags
- Maintain proper indentation
- Ensure accessibility

CSS

- Use external stylesheets
- Use Flexbox and CSS Grid
- Keep styles organized

JavaScript

- Use ES6+ syntax
- Create reusable functions
- Validate all forms
- Handle errors properly

General

- Write clean code
- Avoid duplication
- Use meaningful names
- Add comments where necessary

---

## Folder Structure

Generate code using this structure:

SmartTravelPlanner/

- index.html
- pages/
- css/
- js/
- sql/
- assets/
- general/

---

## Development Order

1. Database Design
2. Authentication Module
3. Dashboard
4. Trip Management
5. Expense Tracking
6. Travel Checklist
7. Reports and Analytics
8. Admin Features
9. Dark Mode
10. Testing and Optimization

---

## Expected Output

When generating code:

- Explain the solution.
- Generate complete files.
- Follow project structure.
- Keep design responsive.
- Follow all coding standards.
- Maintain consistency across the project.
