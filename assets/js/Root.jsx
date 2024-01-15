import React from "react";
import {
  createBrowserRouter,
  RouterProvider,
  redirect,
} from "react-router-dom";
import {
  ApolloClient,
  InMemoryCache,
  ApolloProvider,
  createHttpLink,
} from "@apollo/client";
import { setContext } from "@apollo/client/link/context";
import { ToastContainer } from "react-toastify";

import HomePage from "./pages/HomePage";
import LoginPage from "./pages/LoginPage";
import Layout from "./pages/Layout";
const TOKEN_NAME = "chorely_token";

const protectedLoader = ({ request }) => {
  const token = localStorage.getItem(TOKEN_NAME);

  if (!token) {
    let params = new URLSearchParams();
    params.set("from", new URL(request.url).pathname);
    return redirect("/login");
  }
  return null;
};

const httpLink = createHttpLink({
  uri: "/graphql",
});

const authLink = setContext((_, { headers }) => {
  // get the authentication token from local storage if it exists
  const token = localStorage.getItem(TOKEN_NAME);
  // return the headers to the context so httpLink can read them
  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : "",
    },
  };
});

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache(),
});

const router = createBrowserRouter([
  {
    id: "root",
    path: "/",
    children: [
      {
        path: "/login",
        Component: LoginPage,
      },
      {
        path: "/",
        loader: protectedLoader,
        children: [
          {
            path: "/",
            Component: HomePage,
          },
        ],
        Component: Layout,
      },
    ],
  },
]);

export default () => {
  return (
    <ApolloProvider client={client}>
      <RouterProvider router={router} />
      <ToastContainer position={"bottom-center"} />
    </ApolloProvider>
  );
};
