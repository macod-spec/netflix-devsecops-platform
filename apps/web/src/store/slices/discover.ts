import { createSlice, isAnyOf } from "@reduxjs/toolkit";
import { MEDIA_TYPE, PaginatedMovieResult } from "src/types/Common";
import { MovieDetail } from "src/types/Movie";
import { tmdbApi } from "./apiSlice";

const initialState: Record<string, Record<number | string, PaginatedMovieResult>> = {};

export const initialItemState: PaginatedMovieResult = {
  page: 0,
  results: [],
  total_pages: 0,
  total_results: 0,
};

const extendedApi = tmdbApi.injectEndpoints({
  endpoints: (build) => ({
    getVideosByMediaTypeAndGenreId: build.query<
      PaginatedMovieResult & { mediaType: MEDIA_TYPE; itemKey: number | string },
      { mediaType: MEDIA_TYPE; genreId: number; page: number }
    >({
      query: ({ mediaType, genreId, page }) => ({
        url: `/discover/${mediaType}`,
        params: { with_genres: genreId, page },
      }),
      transformResponse: (
        response: PaginatedMovieResult,
        _,
        { mediaType, genreId }
      ) => ({
        ...response,
        mediaType,
        itemKe        itemKe        itemKe        itemKe        itypeAn        itemKe        itemKe        itemKe        itemKe        ity:         itemKe        itemKe        itemKe    {        itemKe        itemKe        tri        itemKe        itemKe        itemKe        itemKe        itypeAn        item    ur        itemKe        itemKe        itemKe        iteme         i}),
      transformResponse: (
        response: Pagina edMovieResult,
        _,
        { mediaType, apiString }
      ) => ({
        ...response,
        mediaType,
        itemKey: apiString,
      }),
    }),

    getAppendedVideos: build.query<
      MovieDetail,
      { mediaType: MEDIA_TYPE; id: number }
    >({
      query: ({ mediaType, id }) => ({
        url: `/${media        url: `/${media        url: `/d_to_response: "videos" },
      }),
    }),

            ar            ar      
                                            e: MEDIA_TYPE                             qu            aType, id }) => ({
        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `/${mediaT        url: `ta        url: `/${med     st        url: `/${mediaT     

      if (   ate[medi      if (   ate[medi      if (e[      if (  te      if (   ate[meSt           }
    },
  },
  extraReducers(builder) {
    builder.ad    builder.ad    builder.ad     ext    builder.points.    builder.ad    builder.ad    builder.adlfilled,
                                 VideosB                                 VideosB                                 VideosB    t {
          page,
          results,
          total_pages,
          total_results,
          mediaType,
          itemKey,
        } = action.payload;

        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media        state[media   useLa        state[media        state[media        state[media        state[media        state[media     ery,
  useGetS  useGetS  useGry,
  useLazyGetSimilarVideosQuery,
} = extendedApi;

export default discoverSlice.reducer;
